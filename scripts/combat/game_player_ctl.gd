class_name PlayerCtl extends Node

var turn: bool = true
@onready var battle_manager = get_tree().get_root().get_node("BattleRoom").get_node("BattleManager")
@onready var UI_node = get_tree().get_root().get_node("BattleRoom").get_node("CanvasLayer").get_node("UI")
var deck_order = range(52)
var ai_diff = 0
var sp: Node = null
const v0 = Vector2i(0,0) #NOT vercel
const max_hp = 26
var hp: int = max_hp
var hp_display: Label
var block_display: Label
var block_current: Array[int] = [0]
var block_history: int = 1
var next_turn: Array[Callable] = []
var block_accumulator: Array[Array] = [[0]]
var is_enemy: bool = false
var equipped: Array[int] = []
var equipped_cards: Array[GameCard] = []
var hand: Array[int] = []
var burn: Array[int] = []
var removed_from_game: Array[int] = []
var permanent_deck: Array[GameCard] = []
var equipped_display: HBoxContainer
func draw(count: int = 1, gui: bool = false) -> void:
	var slot_res: Array
	var vis_card: Control = null
	var data: GameCard
	for i in range(count):
		if gui:
			slot_res = sp.get_point_slot()
			if slot_res[0] != -1 and len(sp.hidden_cards) > 0:
				hand.append(deck_order.pop_back())
				vis_card = sp.hidden_cards.pop_back()
				vis_card.index_in_deck = hand[-1]
				data = permanent_deck[hand[-1]]
				vis_card.update_img(data.suit,data.id)
				vis_card.global_position = UI_node.get_node("DeckPos").global_position
				vis_card.visible = true
				vis_card.last_point = slot_res[1]
				vis_card.dup_point = slot_res[1]
				vis_card.current_point = slot_res[1]
				sp.occupied[slot_res[1]] = vis_card
				vis_card.tween_to_point(slot_res[1],0.25)
			else: printerr("slots returned "+str(slot_res)+", hidden cards "+str(sp.hidden_cards))
		else: hand.append(deck_order.pop_back())
			
			
			

static func starter_deck() -> Array[GameCard]:
	var deck: Array[GameCard] = []
	for i in range(5):
			deck.append(CardDatabase.db[0][0])
			deck.append(CardDatabase.db[0][1]) #preparation for starter deck
	for i in range(3):
			deck.append(CardDatabase.db[0][2])
	for i in range(5):
			deck.append(CardDatabase.db[1][0])
			deck.append(CardDatabase.db[1][0])
	for i in range(3):
			deck.append(CardDatabase.db[1][0])
	pass
	for i in range(5):
			deck.append(CardDatabase.db[3][0])
			deck.append(CardDatabase.db[3][1])
	for i in range(3):
		deck.append(CardDatabase.db[3][2])
	return deck

static func create(battle_room: Node, deck: Array[GameCard] = [], init_is_enemy: bool = false) -> PlayerCtl:
	var ctl = PlayerCtl.new()
	ctl.battle_manager = battle_room.get_node("BattleManager")
	ctl.UI_node = battle_room.get_node("CanvasLayer/UI")
	if deck == []:
		deck = starter_deck()
	ctl.deck_order = range(len(deck))
	ctl.deck_order.shuffle()
	deck.append(CardDatabase.db[5][0])
	deck.append(CardDatabase.db[5][1])
	ctl.equipped.append(len(deck)-1)
	ctl.equipped.append(len(deck)-2)
	var snap_points = battle_room.get_node("CanvasLayer/SnapPoints")
	ctl.sp = snap_points
	print(snap_points.occupied)
	const fallback_hand_start: bool = false
	if !init_is_enemy:
		if fallback_hand_start and battle_room: #workaround until cards are instantiated by PlayerCtl
			ctl.hand.append(0)
			ctl.hand.append(1)
			ctl.hand.append(10)
			ctl.hand.append(13)
			snap_points.get_node("VisualCard").index_in_deck = 0
			snap_points.get_node("VisualCard").update_img(0,0)
			snap_points.get_node("VisualCard2").index_in_deck = 13
			snap_points.get_node("VisualCard2").update_img(1,0)
			snap_points.get_node("VisualCard3").index_in_deck = 1
			snap_points.get_node("VisualCard3").update_img(0,1)
			snap_points.get_node("VisualCard4").index_in_deck = 10
			snap_points.get_node("VisualCard4").update_img(0,2)
			ctl.deck_order.pop_at(13)
			ctl.deck_order.pop_at(10)
			ctl.deck_order.pop_at(1)
			ctl.deck_order.pop_front()
		else:
			var to_hide: Array[Control] = [snap_points.get_node("VisualCard"),snap_points.get_node("VisualCard2"),
			snap_points.get_node("VisualCard3"),snap_points.get_node("VisualCard4"),
			snap_points.get_node("VisualCard5")]
			for i in to_hide:
				i.visible = false
				snap_points.hidden_cards.append(i)
			print(snap_points.hidden_cards)
	ctl.permanent_deck = deck
	ctl.is_enemy = init_is_enemy
	return ctl
	
func run_equipped(method: String, vec: Vector2i = Vector2i(0,0),prio_type: String = "other",feedback: bool = false):
	var targets = range(len(equipped))
	var prio = 0
	var _counter: int = len(equipped)
	var enemy = battle_manager.get_oppo(is_enemy)
	while targets != [] and prio < 10: #execute modifier methods in priority order
		var i = 0
		while i < len(targets):
			var eq_index = targets[i]
			var eq_card_index = equipped[eq_index]
			var eq = permanent_deck[eq_card_index]
			if eq.prio.get(prio_type) == prio:
				if eq.get(method):
					var m = eq.get(method)
					if feedback: #do not forget to set feedback=true during dmg/block calculations which return!
						vec = m.call(vec,self,enemy)
					else:
						m.call(vec,self,enemy)
					targets.pop_at(i)
					_counter -= 1
					i -= 1 #fix iter position after deleting
				else:
					print("equipment "+eq.name+" p"+str(prio)+" lacks "+method)
					pass
			i += 1
		prio += 1
	return vec

func receive_dmg(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_dmg_in",dmg,"dmg_in",true)
	block_current[dmg[1]] += dmg[0]
	dmg[0] = 0
	if block_current[dmg[1]] > 0:
		dmg[0] += block_current[dmg[1]]
		block_current[dmg[1]] = 0
		block_display.text = "0"
		print("receiving final dmg "+str(dmg))
		hp -= dmg[0]
	else:
		print("blocked dmg, remaining block "+str(block_current))
		block_display.text = str(-block_current[0])
	hp_display.text = str(hp)+" HP"
	pass


func exec_atk(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_dmg_out",dmg,"dmg_out",true)
	print("E"+str(is_enemy)+" dealing final dmg "+str(dmg))
	battle_manager.call_as_player("receive_dmg",[dmg],is_enemy)
	
func exec_block(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_block",dmg,"block",true)
	print("final block "+str(dmg))
	block_accumulator[dmg[1]][-1] += dmg[0]
	
func turn_end() -> void:
	run_equipped("turn_end")
	var type_i: int = 0
	while type_i < len(block_accumulator):
		var sum = 0
		for i in block_accumulator[type_i]:
			sum += i
		block_current[type_i] = sum
		if len(block_accumulator[type_i]) >= block_history:
			block_accumulator[type_i].pop_front()
			block_accumulator[type_i].append(0)
		type_i += 1
	block_display.text = str(-block_current[0])
	UI_node.get_node("Play").visible = false
	turn = false
		
func turn_begin() -> void:
	block_display.text = str(-block_current[0])
	draw(1,!is_enemy)	
	enemy_display_cards(false)
	turn = true
	if !is_enemy:
		UI_node.get_node("Play").visible = true

func player_attack(block:bool=false,choice: bool = false) -> void:
	if not choice:
		var res_card: GameCard = null
		var card: GameCard
		var req
		if block: req = GameCard.Able.BLOCK
		else: req = GameCard.Able.ATK
		for index in equipped:
			card = permanent_deck[index]
			if card.able == req and card.weapon_atk:
				res_card = card
		if res_card:
			print("auto chose "+str(res_card.name))
			if block:
				exec_block(res_card.weapon_atk(v0,self,battle_manager.get_oppo(is_enemy)))
			else:
				exec_atk(res_card.weapon_atk(v0,self,battle_manager.get_oppo(is_enemy)))
		else:
			print("no suitable card found in "+str(equipped))
	else:
		print("executing choice")
		

func play_card(card_index: int) -> Vector2i:
	var loc = -1
	var ind = -1
	const M = GameCard.Move
	if hand.has(card_index):
		loc = 0
		ind = hand.find(card_index)
	elif burn.has(card_index):
		loc = 1
		ind = burn.find(card_index)
	elif deck_order.has(card_index):
		loc = 2
		ind = deck_order.find(card_index)
	elif removed_from_game.has(card_index):
		loc = 3
		ind = removed_from_game.has(card_index)
	else:
		printerr("card #"+str(card_index)+" name "+permanent_deck[card_index].name+" not present in hand "+str(hand)+" or elsewhere")
		return Vector2i(int(M.STAY),loc)
	var card: GameCard = permanent_deck[card_index]
	var res: Array = card.play.call(self,battle_manager.get_oppo(is_enemy))
	if len(res) > 1 and res[1] != v0:
		exec_atk(res[1])
	if len(res) > 2 and res[2] != v0:
		exec_block(res[2])
	var side_int = 0
	if is_enemy: side_int = 1
	match res[0]:
		M.STAY:
			return Vector2i(int(M.STAY),loc)
		M.EQUIP:
			equipped.append(card_index)
			equipped_cards.append(card)
			card.when_equipped.call(self,battle_manager.get_oppo(is_enemy))
			run_equipped("mod_any_equipped",Vector2i(card_index,side_int))
			for child in equipped_display.get_children():
				if child.texture:
					continue
				else:
					child.texture = card.img
					print("found free equipped spot: "+str(child))
					break
		M.RFG:
			removed_from_game.append(card_index)
		M.TRASH:
			burn.append(card_index)
			run_equipped("mod_any_trashed",Vector2i(card_index,side_int))
	match loc:
		0: hand.pop_at(ind)
		1: burn.pop_at(ind)
		2: deck_order.pop_at(ind)
		3: removed_from_game.pop_at(ind)
	return Vector2i(res[0],loc)
			
func enemy_display_cards(show: bool = true, cards: Array[int] = []) -> void:
	var i: int = 0
	var node: TextureRect = null
	var card: GameCard
	for node_name in ["EnemyCard"]:
		node = UI_node.get_node(node_name)
		if show:
			if i < len(cards):
				card = permanent_deck[cards[i]]
				node.texture = card.img
				node.visible = true
				print("displayed "+card.name)
				i += 1
		else:
			node.visible = false
func ai_turn() -> void:
	print("AI turn at "+str(ai_diff)+" difficulty")
	turn_begin()
	match ai_diff:
		_:
			hand.shuffle()
			var single_tar = hand[0]
			print("AI playing "+permanent_deck[single_tar].name+" from hand "+str(hand))
			enemy_display_cards(true, hand)
			play_card(single_tar)
			print("hand after playing "+str(hand))
	turn_end()
		
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

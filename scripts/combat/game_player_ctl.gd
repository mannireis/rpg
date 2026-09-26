class_name PlayerCtl extends Node

enum TurnState {ACTIVE, INACTIVE}
@onready var battle_manager = get_tree().get_root().get_node("BattleRoom").get_node("BattleManager")
var deck_order = range(52)
const v0 = Vector2i(0,0) #NOT vercel
const max_hp = 26
var hp: int = max_hp
var hp_display: Label
var is_enemy: bool = false
var block_current: Array[int] = [0]
var block_history: int = 1
var next_turn: Array[Callable] = []
var block_accumulator: Array[Array] = [[0]]
var equipped: Array[int] = []
var hand: Array[int] = []
var burn: Array[int] = []
var removed_from_game: Array[int] = []
var permanent_deck: Array[GameCard] = []
func draw(count: int = 1) -> void:
	for i in range(count):
		hand.append(deck_order.pop_back())

static func create(battle_room: Node, deck: Array[GameCard] = [], init_is_enemy: bool = false) -> PlayerCtl:
	var ctl = PlayerCtl.new()
	ctl.battle_manager = battle_room.get_node("BattleManager")
	if deck == []:
		for i in range(5):
			deck.append(CardDatabase.db[0][0])
			deck.append(CardDatabase.db[0][1]) #preparation for starter deck
		for i in range(3):
			deck.append(CardDatabase.db[0][0]) #will be different cards once i conjure more images for them
		for i in range(5):
			deck.append(CardDatabase.db[1][0])
			deck.append(CardDatabase.db[1][0])
		for i in range(3):
			deck.append(CardDatabase.db[1][0])
	ctl.deck_order = range(len(deck))
	ctl.deck_order.shuffle()
	deck.append(CardDatabase.db[5][0])
	deck.append(CardDatabase.db[5][1])
	ctl.equipped.append(len(deck)-1)
	ctl.equipped.append(len(deck)-2)
	var snap_points = battle_room.get_node("CanvasLayer/SnapPoints")
	if init_is_enemy:
		if true and battle_room: #workaround until cards are instantiated by PlayerCtl
			ctl.hand.append(0)
			ctl.hand.append(13)
			snap_points.get_node("VisualCard").index_in_deck = 0
			snap_points.get_node("VisualCard").update_img(0,0)
			snap_points.get_node("VisualCard2").index_in_deck = 13
			snap_points.get_node("VisualCard2").update_img(1,0)
			snap_points.get_node("VisualCard3").index_in_deck = 1
			snap_points.get_node("VisualCard3").update_img(0,1)
			ctl.deck_order.pop_at(13)
			ctl.deck_order.pop_front()
		var cards_on_screen: Array[Control]
		var visual_card: Control
		for i in range(5):
			visual_card = snap_points.get_node("VisualCard").duplicate()
			snap_points.add_child(visual_card)
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
				if eq.has_method(method):
					if feedback: #do not forget to set feedback=true during dmg/block calculations which return!
						vec = eq.call(method,vec,self,enemy)
					else:
						eq.call(method,vec,self,enemy)
					targets.pop_at(i)
					_counter -= 1
					i -= 1 #fix iter position after deleting
				else:
					printerr("equipment "+eq.name+" p"+prio+" lacks "+method)
			i += 1
		prio += 1
	return vec

func receive_dmg(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_dmg_in",dmg,"dmg_in",true)
	block_current[dmg[1]] -= dmg[0]
	dmg[0] = 0
	if block_current[dmg[1]] < 0:
		dmg[0] -= block_current[dmg[1]]
		print("receiving final dmg "+str(dmg))
		hp -= dmg[0]
	else:
		print("blocked dmg, remaining block "+str(block_current))
	hp_display.text = str(hp)
	pass


func exec_atk(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_dmg_out",dmg,"dmg_out",true)
	print("final dmg "+str(dmg))
	battle_manager.call_as_player("receive_dmg",[dmg],is_enemy)
	
func exec_block(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_block",dmg,"block",true)
	print("final block "+str(dmg))
	block_accumulator[dmg[1]][-1] += dmg[0]
	
func turn_end() -> void:
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
	if res[1] != v0:
		exec_atk(res[1])
	if res[2] != v0:
		exec_block(res[2])
	var side_int = 0
	if is_enemy: side_int = 1
	match res[0]:
		M.STAY:
			return Vector2i(int(M.STAY),loc)
		M.EQUIP:
			equipped.append(card_index)
			card.when_equipped(self,battle_manager.get_oppo(is_enemy))
			run_equipped("mod_any_equipped",Vector2i(card_index,side_int))
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
	return Vector2i(int(res[0]),loc)
			
			
		
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

class_name PlayerCtl extends Node

enum TurnState {ACTIVE, INACTIVE}
@onready var battle_manager = get_tree().get_root().get_node("BattleManager")
var deck_order = range(52)
const v0 = Vector2i(0,0) #NOT vercel
const max_hp = 26
var hp = max_hp
var block_current: int = 0
var block_history: int = 1
var next_turn: Array[Callable] = []
var block_accumulator: Array[int] = [0]
var equipped: Array[int] = []
var hand: Array[int] = []
var burn: Array[int] = []
var removed_from_game: Array[int] = []
var permanent_deck: Array[GameCard] = []
func draw(count: int = 1) -> void:
	for i in range(count):
		hand.append(deck_order.pop_back())

static func create(deck: Array[GameCard] = []) -> PlayerCtl:
	var ctl = PlayerCtl.new()
	ctl.deck_order.shuffle()
	ctl.permanent_deck = deck
	return ctl
	
func run_equipped(method: String,enemy, vec: Vector2i = Vector2i(0,0),prio_type: String = "other",feedback: bool = false):
	var targets = range(len(equipped))
	var prio = 0
	var _counter: int = len(equipped)
	while targets != [] and prio < 10: #execute modifier methods in priority order
		var i = 0
		while i < len(targets):
			var eq_index = targets[i]
			var eq = equipped[eq_index]
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
	dmg = run_equipped("mod_dmg_in",battle_manager.enemy,dmg,"dmg_in",true)
	print("receiving final dmg "+str(dmg))
	hp -= dmg[0]
	pass


func exec_atk(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_dmg_out",battle_manager.enemy,dmg,"dmg_out",true)
	print("final dmg "+str(dmg))
	battle_manager.call_as_player("receive_dmg",[dmg],true)
	
func exec_block(dmg:Vector2i) -> void:
	dmg = run_equipped("mod_block",battle_manager.enemy,dmg,"block",true)
	print("final block "+str(dmg))
	block_accumulator[-1] += dmg[0] #TODO: block typing & dmg typing
func play_card(card_index: int) -> void:
	var loc = -1
	var ind = -1
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
		return
	var card: GameCard = permanent_deck[card_index]
	var res = card.play(self,battle_manager.enemy)
	const M = GameCard.Move
	if res[1] != v0:
		exec_atk(res[1])
	if res[2] != v0:
		exec_block(res[2])
	match res[0]:
		M.STAY:
			return
		M.EQUIP:
			equipped.append(card_index)
			card.when_equipped(self,battle_manager.enemy)
			run_equipped("mod_any_equipped",battle_manager.enemy,Vector2i(card_index,card.suit))
		M.RFG:
			pass
			
			
		
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

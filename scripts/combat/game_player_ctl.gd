class_name PlayerCtl extends Node

enum TurnState {ACTIVE, INACTIVE}
@onready var battle_manager = get_tree().get_root().get_node("BattleManager")
var deck_order = range(52)
const max_hp = 26
var hp = max_hp
var block_current: int = 0
var block_history: int = 1
var next_turn: Array[Callable] = []
var block_accumulator: Array[int] = []
var equipped: Array[int] = []
var hand: Array[int] = []
var burn: Array[int] = []
var removed_from_game: Array[int] = []
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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

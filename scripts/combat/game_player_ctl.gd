class_name PlayerCtl extends Node

var deck_order = range(52)
var hp = 26
var next_turn: Array[Callable] = []
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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

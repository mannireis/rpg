class_name GameCard extends Node
enum Suit { SPADES, CLUBS, HEARTS, DIAMONDS, OTHER }
var atk: Vector2i = Vector2i(0,0)
var equipped: bool = false
var used_turn: bool = false
static func create(suit: Suit, id: int, can_atk: bool, atk_dmg: Vector2i = Vector2i(0,0), cardname:String = "", text:String = "") -> GameCard:
	var card = GameCard.new()
	card.suit = suit
	card.id = id
	card.can_atk = can_atk
	card.atk = atk_dmg
	card.name = cardname
	card.text = text
	card.prio.dmg_in = 0 #controls which equipment gets priority for modifiers
	card.prio.dmg_out = 0
	return card
	
func mod_dmg_in(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return dmg
	
func mod_dmg_out(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:	
	return dmg

func weapon_atk(_ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return atk
	
func mod_trash_choice(_ctl:PlayerCtl) -> int:
	return -1
	
func mod_discard_event(_choice: int, _ctl: PlayerCtl) -> void:
	pass
	
func next_turn_effect(_ctl: PlayerCtl) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

class_name GameCard extends Resource
enum S { SPADES, CLUBS, HEARTS, DIAMONDS, OTHER }
enum Move { STAY, EQUIP, TRASH, RFG }
#meant to be constant, do not store game state info inside
@export var atk: Vector2i = Vector2i(0,0)
static func create(suit: S, id: int, can_atk: bool, atk_dmg: Vector2i = Vector2i(0,0), cardname:String = "", img_override:String = "", text:String = "") -> GameCard:
	var card = GameCard.new()
	card.suit = suit
	card.id = id
	card.can_atk = can_atk
	card.atk = atk_dmg
	card.name = cardname
	card.img_override = img_override
	card.text = text
	card.prio.dmg_in = 5 #controls which equipment gets priority for modifiers
	card.prio.dmg_out = 5
	card.prio.other = 5
	return card
	
func play(_null, _ctl:PlayerCtl, _enemy_ctl: PlayerCtl) -> Array:
	return [Move.TRASH,Vector2i(0,0),Vector2i(0,0)]
# _null arguments make for easier call() with known number of args
func mod_dmg_in(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return dmg
func mod_dmg_out(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:	
	return dmg
func weapon_atk(_null, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return atk
func mod_trash_choice(_null, _ctl:PlayerCtl, _null2) -> int:
	return -1
func mod_discard_event(_choice: Vector2i, _ctl: PlayerCtl, _null2) -> void:
	pass
func next_turn_effect(_null,_ctl: PlayerCtl,_null2) -> void:
	pass
func mod_block(block: Vector2i, _ctl: PlayerCtl,_enemy_ctl: PlayerCtl) -> Vector2i:
	return block
func turn_begin(_null,_ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> void:
	pass
func turn_end(_null,_ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

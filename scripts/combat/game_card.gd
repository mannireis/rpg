class_name GameCard extends Resource
enum S { SPADES, CLUBS, HEARTS, DIAMONDS, JOKER, OTHER }
enum Move { STAY, EQUIP, TRASH, RFG }
enum Able { NONE, ATK, BLOCK}
#meant to be constant, do not store game state info inside
var atk: Vector2i
var suit: S
var id: int
var cost: int
var able: Able
var name: String
var img: Texture2D
var text: String = ""
var prio = {"dmg_in":5,"dmg_out":5,"block":5,"other":5}
static func create(suit: S, id: int, can_atk: Able, atk_dmg: Vector2i = Vector2i(0,0), cardname:String = "", cardcost:int = 1, img_texture:Texture2D = null, text:String = "") -> GameCard:
	var card = GameCard.new()
	card.suit = suit
	card.id = id
	card.able = can_atk
	card.atk = atk_dmg
	card.name = cardname
	card.cost = cardcost
	card.img = img_texture
	card.text = text
	return card
	
var play: Callable = func play(_ctl:PlayerCtl, _enemy_ctl: PlayerCtl) -> Array:
	return [Move.TRASH,Vector2i(0,0),Vector2i(0,0)]

func when_equipped(_ctl:PlayerCtl, _enemy_ctl: PlayerCtl) -> void: #doesn't need priority so no _null
	pass

 #_null arguments make for easier call() with known number of args
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
func mod_any_equipped(side_card_index: Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> void:
	pass
func mod_any_trashed(side_card_index: Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> void:
	pass
func turn_begin(_null,_ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> void:
	pass
func turn_end(_null,_ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> void:
	pass

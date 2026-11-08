class_name GameCard extends Resource
enum S { SPADES, CLUBS, HEARTS, DIAMONDS, JOKER, OTHER }
enum Move { STAY, EQUIP, TRASH, RFG }
enum Able { NONE, ATK, BLOCK }
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


func _init(suit: S, id: int, can_atk: Able, atk_dmg: Vector2i = Vector2i(0,0), cardname:String = "", cardcost:int = 1, img_texture:Texture2D = null, text:String = ""):
	self.suit = suit
	self.id = id
	self.able = can_atk
	self.atk = atk_dmg
	self.name = cardname
	self.cost = cardcost
	self.img = img_texture
	self.text = text

var play := func play(_ctl:PlayerCtl, _enemy_ctl: PlayerCtl) -> Array:
	return [Move.TRASH]

var when_equipped := func when_equipped(_ctl:PlayerCtl, _enemy_ctl: PlayerCtl) -> void: #doesn't need priority so no _null
	pass

 #_null arguments make for easier call() with known number of args
var mod_dmg_in := func mod_dmg_in(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return dmg
var mod_dmg_out := func mod_dmg_out(dmg:Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:	
	return dmg
var weapon_atk := func weapon_atk(_null, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> Vector2i:
	return atk
var mod_trash_choice := func mod_trash_choice(_null, _ctl:PlayerCtl, _null2) -> int:
	return -1
var mod_discard_event := func mod_discard_event(_choice: Vector2i, _ctl: PlayerCtl, _null2) -> void:
	pass
var next_turn_effect := func next_turn_effect(_null,_ctl: PlayerCtl,_null2) -> void:
	pass
var mod_block := func mod_block(block: Vector2i, _ctl: PlayerCtl,_enemy_ctl: PlayerCtl) -> Vector2i:
	return block
var mod_any_equipped := func mod_any_equipped(_side_card_index: Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> void:
	pass
var mod_any_trashed := func mod_any_trashed(_side_card_index: Vector2i, _ctl: PlayerCtl, _enemy_ctl: PlayerCtl) -> void:
	pass
var turn_begin := func turn_begin(_null,_ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> void:
	pass
var turn_end := func turn_end(_null,_ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> void:
	pass

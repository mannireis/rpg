class_name CardList
extends Node
const n = GameCard.Able.NONE
const s = GameCard.S
const v0 = Vector2i(0,0)
const p = "res://assets/aseprite/cards/"
var common_textures: Array[Texture2D] = [
	preload(p+"bad_card.png")
]
var db: Array[Array] = [
[GameCard.create(s.SPADES,0,n,v0,"Double Trouble",1,preload(p+"0/0.png")),
GameCard.create(s.SPADES,0,n,Vector2i(10,0),"Barbaric Strike",2,preload(p+"0/1.png"))],
[GameCard.create(s.CLUBS,0,n,v0,"Good Posture",1,preload(p+"1/0.png"))],
[],
[],
[],
[GameCard.create(s.OTHER,0,GameCard.Able.ATK,Vector2i(3,0),"Punch",0),
GameCard.create(s.OTHER,0,GameCard.Able.BLOCK,Vector2i(-3,0),"Block",0)]]

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(typeof(db[0][0].play))
	db[0][0].play = func(ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> Array:
		ctl.player_attack() #glorious impl of a dual punch
		ctl.player_attack()
		return [GameCard.Move.TRASH,v0,v0]
	db[0][1].play = func(ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> Array:
		ctl.exec_atk(db[0][1].atk)
		if _enemy_ctl.hp > 0:
			_enemy_ctl.player_attack()
		return [GameCard.Move.TRASH,v0,v0]
	db[1][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.player_attack(true)
		ctl.player_attack(true)
		return [GameCard.Move.TRASH,v0,v0]

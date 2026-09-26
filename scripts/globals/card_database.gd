class_name CardList
extends Node

const v0 = Vector2i(0,0)
const p = "res://assets/aseprite/cards/" #res://assets/aseprite/cards/0/0.png res://assets/aseprite/cards/1/0.png

var db: Array[Array] = [
[GameCard.create(GameCard.S.SPADES,0,GameCard.Able.NONE,v0,"Double Trouble",1,preload(p+"0/0.png"))],
[GameCard.create(GameCard.S.CLUBS,0,GameCard.Able.NONE,v0,"Good Posture",1,preload(p+"1/0.png"))],
[],
[],
[],
[GameCard.create(GameCard.S.OTHER,0,GameCard.Able.ATK,Vector2i(3,0),"Punch",0),
GameCard.create(GameCard.S.OTHER,0,GameCard.Able.BLOCK,Vector2i(-3,0),"Block",0)]]

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(typeof(db[0][0].play))
	db[0][0].play = func(ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> Array:
		ctl.player_attack() #glorious impl of a dual punch
		ctl.player_attack()
		return [GameCard.Move.TRASH,v0,v0]
	db[1][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.player_attack(true)
		ctl.player_attack(true)
		return [GameCard.Move.TRASH,v0,v0]

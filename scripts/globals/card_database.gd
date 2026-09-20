class_name CardList extends Node
const v0 = Vector2i(0,0)
const p = "res://assets/aseprite/cards/"
var db: Array[Array] = [
[GameCard.create(GameCard.S.SPADES,0,GameCard.Able.NONE,v0,"Double Trouble",1,preload(p+"0/0.png"))],
[GameCard.create(GameCard.S.CLUBS,0,GameCard.Able.NONE,v0,"Good Posture"),1,preload(p+"1/0.png")],
[],
[],
[],
[GameCard.create(GameCard.S.OTHER,0,GameCard.Able.ATK,Vector2i(3,0),"Punch",0),
GameCard.create(GameCard.S.OTHER,0,GameCard.Able.BLOCK,Vector2i(-3,0),"Block",0)]]
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(db[0][0].play)
	print(TYPE_CALLABLE)
	print(typeof(db[0][0].play))
	var c00 = func(ctl:PlayerCtl,_enemy_ctl: PlayerCtl) -> Array:
		ctl.player_attack()
		ctl.player_attack()
		return [GameCard.Move.TRASH,v0,v0]
	db[0][0].play = c00
	var c10 = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.player_attack(true)
		ctl.player_attack(true)
		return [GameCard.Move.TRASH,v0,v0]
	db[1][0].play = c10
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

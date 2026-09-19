class_name CardList extends Node
const v0 = Vector2i(0,0)
const p = "res://assets/aseprite/cards/"
var db: Array[Array] = [
[GameCard.create(GameCard.S.SPADES,0,false,v0,"Double Trouble",1,preload(p+"0/0.png"))],
[GameCard.create(GameCard.S.CLUBS,0,false,v0,"Good Posture"),1,preload(p+"1/0.png")],
[],
[],
[],
[GameCard.create(GameCard.S.OTHER,0,true,Vector2i(3,0),"Punch",0),
GameCard.create(GameCard.S.OTHER,0,true,Vector2i(-3,0),"Block",0)]]

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

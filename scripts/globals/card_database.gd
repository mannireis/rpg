class_name CardList extends Node
const v0 = Vector2i(0,0)
var db: Array[Array] = [
[GameCard.create(GameCard.S.SPADES,0,false,v0,"Double Trouble")],
[GameCard.create(GameCard.S.CLUBS,0,false,v0,"Good Posture")],
[],
[],
[GameCard.create(GameCard.S.OTHER,0,true,Vector2i(3,0),"Punch"),GameCard.create(GameCard.S.OTHER,0,true,Vector2i(-3,0),"Block")]]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

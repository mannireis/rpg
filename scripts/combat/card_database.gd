class_name CardList extends Node
const v0 = Vector2i(0,0)
var db: Array[Array] = [
[Card.create(Card.S.SPADES,0,false,v0,"Double Trouble")],
[],
[],
[],
[Card.create(Card.S.OTHER,0,true,Vector2i(3,0),"Punch")]]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

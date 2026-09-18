extends Node

@onready var player = PlayerCtl.create()
@onready var enemy = PlayerCtl.create()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func call_as_player(method:String,args: Array, is_enemy: bool = false) -> void:
	if is_enemy:
		enemy.callv(method,args)
	else:
		player.callv(method,args)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

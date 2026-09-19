extends Node

@onready var player = PlayerCtl.create()
@onready var enemy = PlayerCtl.create([],true)

func get_oppo(caller_is_enemy: bool) -> PlayerCtl:
	if caller_is_enemy:
		return player
	else: return enemy #such code, very advance

func call_as_player(method:String,args: Array, is_enemy: bool = false) -> void:
	if is_enemy:
		enemy.callv(method,args)
	else:
		player.callv(method,args)

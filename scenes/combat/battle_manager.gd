extends Node

@onready var player = PlayerCtl.create(get_parent(),[])
@onready var enemy = PlayerCtl.create(get_parent(),[],true)
@onready var snap_points = get_parent().get_node("CanvasLayer/SnapPoints")


func _ready() -> void:
	var c = snap_points.get_node("Container")
	player.hp_display = snap_points.get_node("Container").get_node("PlayerHP")
	player.block_display = c.get_node("PlayerBlock")
	enemy.hp_display = snap_points.get_node("Container").get_node("EnemyHP")
	enemy.block_display = c.get_node("EnemyBlock")


func get_oppo(caller_is_enemy: bool) -> PlayerCtl:
	if caller_is_enemy:
		return player
	else: return enemy #such code, very advance


func call_as_player(method:String,args: Array, is_enemy: bool = false) -> void:
	if !is_enemy:
		enemy.callv(method,args)
	else:
		player.callv(method,args)

extends Node2D

@onready var player: Player = $Player
@onready var animation_player: AnimationPlayer = $CanvasModulate/AnimationPlayer
@onready var camera: Camera2D = $Camera2D


func _ready():
	Signals.transition.connect(_on_transition)


func _process(_delta: float) -> void:
	var viewport := get_viewport_rect().size
	camera.position = (player.position - viewport / 2).snapped(viewport)


func _on_transition(door: Door) -> void:
	match door.transition:
		Door.Transition.NORMAL:
			move_player(door)

		Door.Transition.FADE_CANVAS:
			var player_process_mode := player.process_mode
			player.process_mode = Node.PROCESS_MODE_DISABLED
			animation_player.play("fade_canvas")
			await animation_player.animation_finished
			move_player(door)
			player.process_mode = player_process_mode
			animation_player.play_backwards("fade_canvas")


func move_player(door: Door) -> void:
	player.position = door.other.get_node(^"Marker2D").global_position

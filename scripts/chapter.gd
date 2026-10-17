extends Node2D

@onready var pause_menu: CanvasLayer = %PauseMenu
@onready var main_menu_button: Button = %MainMenuButton
@onready var player: Player = %Player
@onready var animation_player: AnimationPlayer = %CanvasModulate/AnimationPlayer
@onready var camera: Camera2D = %Camera2D


func _ready():
	Signals.transition.connect(_on_transition)
	print(get_viewport_rect().size)
	debug_t()


func _process(_delta: float) -> void:
	var viewport := Vector2(320,180) #hardcoded because get_viewport_rect doesn't work here
	camera.position = (player.position - viewport / 2).snapped(viewport)

	main_menu_button.offset_transform_position = (
		Vector2.ONE if main_menu_button.is_hovered()
		else Vector2.ZERO
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"pause_game") and not ShopUi.visible:
		var tree := get_tree()
		tree.paused = not tree.paused
		pause_menu.visible = not pause_menu.visible


func _on_transition(door: Door) -> void:
	match door.transition:
		Door.Transition.NORMAL:
			move_player(door)

		Door.Transition.FADE_CANVAS:
			var player_process_mode := player.process_mode
			player.process_mode = Node.PROCESS_MODE_DISABLED
			animation_player.play("fade_canvas")
			await animation_player.animation_finished
			camera.position_smoothing_enabled = false
			move_player(door)
			camera.force_update_scroll()
			camera.position_smoothing_enabled = true
			player.process_mode = player_process_mode
			animation_player.play_backwards("fade_canvas")


func move_player(door: Door) -> void:
	player.position = door.other.get_node(^"Marker2D").global_position


func _on_main_menu_button_pressed() -> void:
	var tree := get_tree()
	tree.paused = false
	tree.change_scene_to_file("res://scenes/main_menu.tscn")

func t() -> SceneTreeTimer: return get_tree().create_timer(2)
func debug_t():
	var viewport := get_viewport_rect().size
	print(player.position - viewport / 2)
	print((player.position - viewport / 2).snapped(viewport))
	var timer = t()
	timer.timeout.connect(debug_t)

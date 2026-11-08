extends Node2D

@onready var pause_menu: CanvasLayer = %PauseMenu
@onready var main_menu_button: Button = %MainMenuButton
@onready var player: Player = %Player
@onready var animation_player: AnimationPlayer = %CanvasModulate/AnimationPlayer
@onready var camera: Camera2D = %Camera2D

@export var chapter_name: String

var transitioning := false ## NOT TRANSING MY GENDER

func _ready():
	GameState.time_start = Time.get_unix_time_from_system()
	Signals.transition.connect(_on_transition)
	GameState.chapter_name = chapter_name


func _process(_delta: float) -> void:
	GameState.time_now = Time.get_unix_time_from_system()
	GameState.playtime = GameState.time_now - GameState.time_start
	
	var viewport := get_viewport_rect().size
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
	var marker: Marker2D = door.other.get_node(^"Marker2D")
	
	match door.transition:
		Door.Transition.NORMAL:
			transitioning = true
			player.position = marker.global_position
			transitioning = false

		Door.Transition.FADE_CANVAS:
			fade_canvas(marker.global_position)


func fade_canvas(to: Vector2):
	if transitioning:
		return
	transitioning = true
	camera.position_smoothing_enabled = false
	var player_process_mode := player.process_mode
	player.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("fade_canvas")
	await animation_player.animation_finished
	player.position = to
	camera.force_update_scroll()
	player.process_mode = player_process_mode
	animation_player.play_backwards("fade_canvas")
	await animation_player.animation_finished
	camera.position_smoothing_enabled = true
	transitioning = false


func _on_main_menu_button_pressed() -> void:
	var tree := get_tree()
	tree.paused = false
	SaveManager.save_game(GameState.current_slot)
	tree.change_scene_to_file("res://scenes/ui/main_menu.tscn")

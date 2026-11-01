extends Control

@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	play_button.mouse_entered.connect(_play_audio) and play_button.focus_entered.connect(_play_audio)
	quit_button.mouse_entered.connect(_play_audio) and quit_button.focus_entered.connect(_play_audio)


func _process(_delta: float) -> void:
	play_button.offset_transform_position = (
		Vector2.ONE if play_button.is_hovered()
		else Vector2.ZERO
	)

	quit_button.offset_transform_position = (
		Vector2.ONE if quit_button.is_hovered()
		else Vector2.ZERO
	)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/save_load_menu.tscn")


func _on_quit_button_pressed() -> void:
	_quit()


func _quit() -> void:
	get_tree().quit()

func _play_audio() -> void:
	print("playing")
	$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
	$AudioStreamPlayer.play()

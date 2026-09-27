extends Control

const SAVE_PATH := "user://save.tres"
var save := load(SAVE_PATH) as Save if ResourceLoader.exists(SAVE_PATH) else Save.new()


func _ready() -> void:
	pass


#func _notification(what: int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#ResourceSaver.save(Save.new(), SAVE_PATH)
		#get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(save.room)


func _on_exit_button_pressed() -> void:
	get_tree().quit()

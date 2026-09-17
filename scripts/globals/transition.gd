extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func change_scene_to_file(file: String):
	var tween = create_tween()
	tween.tween_property($ColorRect, "color:a", 1.0, 2.0).from(0.0)
	get_tree().call_deferred("change_scene_to_file", file)
	tween.tween_property($ColorRect, "color:a", 0.0, 2.0).from(1.0)

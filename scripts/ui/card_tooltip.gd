extends PanelContainer

func _process(delta: float) -> void:
	var view = get_viewport_rect().size
	var target = get_global_mouse_position()
	global_position = target.clamp(Vector2.ZERO, view - size)

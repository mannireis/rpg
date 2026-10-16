extends Button

func _physics_process(delta: float) -> void:
	offset_transform_position = (
		Vector2.ONE if is_hovered()
		else Vector2.ZERO
	)

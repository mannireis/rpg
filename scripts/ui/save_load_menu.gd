extends PanelContainer

@onready var button_container: VBoxContainer = $CenterContainer/ButtonContainer

func _process(delta: float) -> void:
	for b in button_container.get_children():
		if b is Button:
			print("yay")
			b.offset_transform_position = (
				Vector2.ONE if b.is_hovered()
				else Vector2.ZERO
			)
		else:
			printerr(b, " is not a Button node")

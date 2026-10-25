@tool
class_name Door
extends Node2D

enum Transition {
	NORMAL,
	FADE_CANVAS,
}

@export var horizontal := false:
	set(value):
		if value == horizontal:
			return

		if not is_node_ready():
			await ready

		horizontal = value
		_set_rotation()
		other.horizontal = horizontal

@export var flip := false:
	set(value):
		if value == flip:
			return

		if not is_node_ready():
			await ready

		flip = value
		_set_rotation()
		other.flip =! flip

@export var width := 2:
	set(value):
		if not is_node_ready():
			await ready

		width = value
		var width_in_pixels := width * 16
		@warning_ignore_start("integer_division")
		shape.a.y = width_in_pixels / -2
		shape.b.y = width_in_pixels / 2
		@warning_ignore_restore("integer_division")

@export var other: Door:
	set(value):
		if other == value:
			return

		if value == null:
			other.other = null

		other = value

		if other != null:
			other.other = self

@export var transition := Transition.NORMAL:
	set(value):
		if transition == value:
			return

		if not is_node_ready():
			await ready

		transition = value
		other.transition = transition

@export var blocking_buttons: Array[Button2D] = []:
	set(value):
		if blocking_buttons == value:
			return

		blocking_buttons = value

		if not is_node_ready():
			await ready

		if blocking_buttons.is_empty():
			_unblock()
		else:
			_block()

		other.blocking_buttons = blocking_buttons 

@onready var shape: SegmentShape2D = $Area2D/CollisionShape2D.shape
@onready var area_2d: Area2D = $Area2D
@onready var blocker_horizontal: Sprite2D = $BlockerHorizontal
@onready var blocker_vertical: Sprite2D = $BlockerVertical


func _ready() -> void:
	for button in blocking_buttons:
		button.toggled.connect(_on_button_toggled)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	Signals.transition.emit(self)


func _on_button_toggled(_value: bool) -> void:
	if blocking_buttons.all(func (button: Button2D) -> bool: return button.is_toggled):
		_unblock()
	else:
		_block()


func _set_rotation() -> void:
	rotation_degrees = 0

	if horizontal:
		rotation_degrees += 90

	if flip:
		rotation_degrees += 180


func _block() -> void:
	area_2d.monitoring = false
	
	if horizontal:
		blocker_horizontal.modulate = Color.WHITE
		blocker_horizontal.show()
	else:
		blocker_vertical.modulate = Color.WHITE
		blocker_vertical.show()


func _unblock() -> void:
	area_2d.monitoring = true
	blocker_horizontal.modulate = Color(1, 1, 1, 0.3)
	blocker_vertical.modulate = Color(1, 1, 1, 0.3)

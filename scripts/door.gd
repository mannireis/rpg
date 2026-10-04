@tool
class_name Door
extends Area2D

enum Transition {
	NORMAL,
	FADE_CANVAS,
}

@export var width := 2:
	set(value):
		if not Engine.is_editor_hint():
			return
		
		width = value
		var width_in_pixels := width * 16
		@warning_ignore_start("integer_division")
		collision_shape.a.y = width_in_pixels / -2
		collision_shape.b.y = width_in_pixels / 2
		@warning_ignore_restore("integer_division")


@export var other: Door:
	set(value):
		match value:
			other:
				return

			null:
				other.other = null

		other = value

		if Engine.is_editor_hint() and other != null:
			other.other = self

@export var transition := Transition.NORMAL:
	set(value):
		if transition == value:
			return

		transition = value

		if Engine.is_editor_hint():
			other.transition = transition

@onready var collision_shape: SegmentShape2D = $CollisionShape2D.shape


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	Signals.transition.emit(self)

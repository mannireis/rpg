@tool
class_name Door
extends Area2D


@export var width := 2:
	set(value):
		if (not Engine.is_editor_hint()):
			return
		
		width = value
		var width_in_pixels := width * 16
		@warning_ignore_start("integer_division")
		collision_shape.a.y = width_in_pixels / -2
		collision_shape.b.y = width_in_pixels / 2
		@warning_ignore_restore("integer_division")


@export var other: Door:
	set(value):
		if (other == value):
			return

		other = value
		other.other = self

@onready var collision_shape: SegmentShape2D = $CollisionShape2D.shape
@onready var player: Player = $"../Player"


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	player.global_position = other.get_node(^"Marker2D").global_position

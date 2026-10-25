class_name Button2D
extends Area2D

signal toggled(value: bool)

var body_count := 0
var is_toggled := false

@onready var sprite: Sprite2D = $Sprite2D


func _on_body_entered(_body: Node2D) -> void:
	body_count += 1

	if body_count >= 1:
		sprite.frame = 1
		is_toggled = true
		toggled.emit(is_toggled)


func _on_body_exited(_body: Node2D) -> void:
	body_count -= 1

	if body_count == 0:
		sprite.frame = 0
		is_toggled = false
		toggled.emit(is_toggled)

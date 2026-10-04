class_name Button2D
extends Area2D

signal toggled(is_on: bool)

var bodies_on_button := 0
var is_on := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("movable_object"):
		bodies_on_button += 1
		if bodies_on_button == 1:
			is_on = true
			toggled.emit(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("movable_object"):
		bodies_on_button -= 1
		if bodies_on_button == 0:
			is_on = false
			toggled.emit(false)

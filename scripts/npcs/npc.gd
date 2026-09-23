class_name NPC
extends CharacterBody2D

@export var dialogue_file: String

@export var id: StringName = &"start"
@export var met_id: StringName = &"start"

var in_range := false
var pressed := false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		pressed = false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact") and in_range and not pressed:
		pressed = true
		if GameState.has_met(id):
			DialogueManager.start(dialogue_file, met_id)
		else:
			DialogueManager.start(dialogue_file, id)
			GameState.meet(id)

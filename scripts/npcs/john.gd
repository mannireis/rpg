extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var id: StringName = &"john"
var in_range := false
var pressed := false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		animated_sprite_2d.play("Thinking")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
		pressed = false
		animated_sprite_2d.play("Idle")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact") and in_range and not pressed:
		pressed = true
		if GameState.has_met(id):
			DialogueManager.start("res://assets/dialogue/john/john_start.txt", "john")
		else:
			DialogueManager.start("res://assets/dialogue/john/john_start.txt", "meet_john")
			GameState.meet(id)

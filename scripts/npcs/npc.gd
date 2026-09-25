class_name NPC
extends CharacterBody2D

@export_category("Dialogue")
@export var dialogue_file: String
@export var id: StringName = &"start"
@export var met_id: StringName = &"start"
@export var area2d: Area2D

@export_category("Wander")
@export var wander: bool = false
@export var max_dist: float = 64.0
@export var speed: float = 25.0
@export var min_wait: float = 1.0
@export var max_wait: float = 5.0

@export_category("Misc")
@export var animation: AnimatedSprite2D

var last_dir := Vector2.DOWN
var starting_pos: Vector2
var target_pos: Vector2
var in_range := false
var pressed := false

func _ready() -> void:
	if wander:
		starting_pos = global_position
		target_pos = starting_pos
		_choose_pos()

	area2d.body_entered.connect(_on_area_2d_body_entered)
	area2d.body_exited.connect(_on_area_2d_body_exited)


func _choose_pos() -> void:
	var angle = randf() * TAU
	var dist = randf() * max_dist
	target_pos = starting_pos + Vector2(cos(angle), sin(angle)) * dist
	
	var wait_time = randf_range(min_wait, max_wait)
	get_tree().create_timer(wait_time).timeout.connect(_choose_pos)


func _physics_process(delta: float) -> void:
	if wander:
		var to_target = target_pos - global_position
		var direction := Vector2.ZERO
		
		if to_target.length() >= 2.0:
			direction = to_target.normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	
		play_animations(direction)
		move_and_slide()


func play_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		last_dir = direction
		if abs(direction.x) > abs(direction.y):
			animation.play("walk_right" if direction.x > 0 else "walk_left")
		else:
			animation.play("walk_down" if direction.y > 0 else "walk_up")
	else:
		if abs(last_dir.x) > abs(last_dir.y):
			animation.play("idle_right" if last_dir.x > 0 else "idle_left")
		else:
			animation.play("idle_down" if last_dir.y > 0 else "idle_up")


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

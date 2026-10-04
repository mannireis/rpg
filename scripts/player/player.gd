class_name Player
extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float = 70.0
@export var friction : float = 1000.0

var last_dir := Vector2.DOWN


func _ready() -> void:
	add_to_group("player")
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		RoomChangeGlobal.activate = false
	if RoomChangeGlobal.emit_battle:
		RoomChangeGlobal.emit_battle = false
		if RoomChangeGlobal.last_battle_result: Signals.battle_won.emit()
		else: Signals.battle_lost.emit()

func _physics_process(delta: float) -> void:
	if DialogueManager.active:
		return

	var direction : Vector2
	
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction:
		velocity = speed * direction.normalized()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	GameState.player_pos = global_position
	
	play_animations(direction)
	move_and_slide()
	
	
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		var collider := c.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(-c.get_normal() * 50.0)


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

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

func _physics_process(delta: float) -> void:
	DialogueManager.start("res://assets/dialogue/testing/test.txt")
	var direction : Vector2
	
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction:
		velocity = speed * direction.normalized()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
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

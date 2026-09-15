extends CharacterBody2D

@export var speed : float = 85.0
@export var friction : float = 1000.0

func _physics_process(delta: float) -> void:
	var direction : Vector2
	
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction:
		velocity = speed * direction.normalized()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

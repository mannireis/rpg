extends CharacterBody2D

@export var speed : float = 120.0

func _physics_process(delta: float) -> void:
	var direction : Vector2
	
	direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	
	if direction:
		velocity = speed * direction
	else:
		velocity = lerp(velocity, Vector2(0,0), 0.8)
	
	move_and_slide()

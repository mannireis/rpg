class_name PushableBlock2D
extends CharacterBody2D

@onready var rays := {
	Vector2.UP: $TopRayCast2D,
	Vector2.DOWN: $BottomRayCast2D,
	Vector2.RIGHT: $RightRayCast2D,
	Vector2.LEFT: $LeftRayCast2D,
}

@export_range(0.0, 10.0) var drag := 5.0
@export_range(0.0, 1.0) var impact_response := 0.5
@export var initial_velocity := Vector2.ZERO


func _ready() -> void:
	add_to_group("movable_object")
	velocity = initial_velocity


func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * impact_response


func _physics_process(delta: float) -> void:
	var player = _get_collider()
	var side := _get_collision_side()

	if velocity.length_squared() > 1.0:
		velocity *= 1.0 - drag * delta
		if move_and_slide():
			resolve_collisions()

	if Input.is_action_pressed("Interact") and player != null:
		if side.x != 0:
			velocity.x = player.velocity.x
		else:
			velocity.y = player.velocity.y
	elif side == Vector2.ZERO:
		velocity.x = 0
	 
	move_and_slide()



func _get_collision_side() -> Vector2:
	for dir in rays:
		var body = rays[dir].get_collider()
		if rays[dir].is_colliding() and body.is_in_group("player"):
			return dir

	return Vector2.ZERO


func _get_collider() -> Node:
	for ray in rays.values():
		if ray.is_colliding():
			var body = ray.get_collider()
			if body.is_in_group("player"):
				return ray.get_collider()
	return null

func resolve_collisions() -> void:
	var current_velocity := velocity
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as PushableBlock2D
		if body:
			apply_impact(body.velocity)
			body.apply_impact(current_velocity)
		else:
			velocity -= velocity.project(collision.get_normal())

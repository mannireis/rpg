class_name PushableBlock2D
extends RigidBody2D

@onready var rays := {
	Vector2.UP: $TopRayCast2D,
	Vector2.DOWN: $BottomRayCast2D,
	Vector2.RIGHT: $RightRayCast2D,
	Vector2.LEFT: $LeftRayCast2D,
}

func _ready() -> void:
	add_to_group("movable_object")


func _physics_process(delta: float) -> void:
	var player = _get_collider()
	var side := _get_collision_side()

	if Input.is_action_pressed("Interact") and player != null:
		if side.x != 0:
			linear_velocity.x = player.velocity.x
		else:
			linear_velocity.y = player.velocity.y
	elif side == Vector2.ZERO:
		linear_velocity.x = 0


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

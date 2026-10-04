class_name PushableBlock2D
extends RigidBody2D

@onready var rays := {
	Vector2.UP: $TopRayCast2D,
	Vector2.DOWN: $BottomRayCast2D,
	Vector2.RIGHT: $TopRayCast2D,
	Vector2.LEFT: $RightRayCast2D,
}

func _physics_process(delta: float) -> void:
	print(get_colliding_bodies())


func _get_collision_side() -> Vector2:
	for dir in rays:
		if rays[dir].is_colliding():
			return dir
	return Vector2.ZERO


func _on_body_entered(body: Node) -> void:
	print("meow")

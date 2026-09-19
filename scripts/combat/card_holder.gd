extends Node

@export var snap_points: Array[Control] = []
@export var points_to_play: Array[Control] = []
var occupied: Dictionary = {} 

func get_nearest_point(global_pos: Vector2) -> Control:
	var nearest: Control = null
	var nearset_dist := INF
	for point in snap_points:
		var point_center = point.global_position + point.size / 2
		var dist = global_pos.distance_squared_to(point_center)
		if dist < nearset_dist:
			nearset_dist = dist
			nearest = point
	return nearest

func play_cards() -> void:
	pass

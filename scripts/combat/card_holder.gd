extends Node

@export var snap_points: Array[Control] = []
@export var points_to_play: Array[Control] = []
@onready var battle_manager = get_tree().get_root().get_node("BattleRoom").get_node("BattleManager")
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
	print("play button clicked")
	var selected_cards: Array[int] = []
	var card_in_slot
	var res: Vector2i
	for p in points_to_play:
		card_in_slot = occupied.get(p)
		if card_in_slot != null:
			selected_cards.append(card_in_slot.index_in_deck)
	for index_in_deck in selected_cards:
		res = battle_manager.player.play_card(index_in_deck)
		

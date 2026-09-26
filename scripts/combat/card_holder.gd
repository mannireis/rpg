extends Node

@onready var battle_manager = get_tree().get_root().get_node("BattleRoom").get_node("BattleManager")

@export var snap_points: Array[Control] = []
@export var points_to_play: Array[Control] = []

var occupied: Dictionary = {} 
var hidden: Array[Control] = []

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
	var selected_cards: Array[Array] = []
	var card_in_slot
	var index_in_deck: int
	var res: Vector2i
	for p in points_to_play:
		card_in_slot = occupied.get(p)
		if card_in_slot != null:
			selected_cards.append([card_in_slot.index_in_deck,card_in_slot,p])
	for a in selected_cards:
		index_in_deck = a[0]
		res = battle_manager.player.play_card(index_in_deck)
		print(res)
		if res[0] != int(GameCard.Move.STAY):
			a[1].visible = false
			hidden.append(a[1])
			occupied.set(a[2],null)
		else:
			print("trying to move #"+str(a[1].index_in_deck)+", last "+str(a[1].last_point)+" current "+str(a[1].current_point))
			occupied.set(a[2],null)
			a[1].current_point = a[1].last_point
			occupied.set(a[1].current_point,a[1])
			if false:
				var tween = a[1].create_tween()
				tween.tween_property(self, "global_position", a[1].last_point.global_position + (a[1].last_point.size - a[1].size) / 2.0, 0.15)
			else:
				if a[1].last_point:
					a[1].dup_point = a[1].last_point
					a[1].global_position = a[1].last_point.global_position
	if len(selected_cards) > 0:
		battle_manager.player.turn_end()
		battle_manager.enemy.ai_turn()

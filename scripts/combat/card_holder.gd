extends Node

@onready var battle_manager = get_tree().get_root().get_node("BattleRoom").get_node("BattleManager")

@export var snap_points: Array[Control] = []
@export var points_to_play: Array[Control] = []

var occupied: Dictionary = {} 
var hidden_cards: Array[Control] = []
var sel_autosubmit: bool = true ## Once enough cards have been selected, emit cards_selected
var sel_cards = [] ## Returns VisualCards, get .index_in_deck from them
var sel_count: int = 0 ## Non-zero value retains selection mode until that many cards have been selected
signal cards_selected ## Set sel_autosubmit and sel_count in SnapPoints, when signal fires, collect resulting VisualCards in sel_cards 

func _ready() -> void:
	cards_selected.connect(_cards_selected_cleanup)

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

func get_point_slot() -> Array:
	var ii: int = 0
	var p: Control = null
	for i in snap_points:
		if i not in points_to_play and !occupied.get(i):
			p = i
			break
		ii += 1
	if !p: ii = -1
	#print("found free point "+str(p)+" at ii "+str(ii))
	return([ii,p])

func exec_turn():
	battle_manager.player.turn_end()
	await get_tree().create_timer(1).timeout
	battle_manager.enemy.ai_turn()
	await get_tree().create_timer(2).timeout
	battle_manager.player.turn_begin()

func _cards_selected_cleanup() -> void:
	sel_count = 0
	for vc in sel_cards:
		vc.get_node("WhiteFrame").visible = false
		occupied.set(vc.current_point,null)
	Input.set_custom_mouse_cursor(null)
	await get_tree().create_timer(0.2).timeout
	if sel_count == 0: sel_cards = [] # mutex-ish

func _default_action(block: bool = false) -> void:
	var c
	for p in points_to_play:
		c = occupied.get(p)
		if c:
			print("refusing default action due to "+str(c))
			return
	battle_manager.player.player_attack(block)
	exec_turn()


func play_cards() -> void:
	var selected_cards: Array[Array] = []
	var card_in_slot
	var index_in_deck: int
	var res: Vector2i
	for p in points_to_play:
		card_in_slot = occupied.get(p)
		if card_in_slot != null:
			selected_cards.append([card_in_slot.index_in_deck,card_in_slot,p,card_in_slot.data.cost])
	var sum_cost: int = 0
	for a in selected_cards:
		sum_cost += a[3]
	if sum_cost > battle_manager.player.energy:
		print("sum cost "+str(sum_cost)+" exceeds "+str(battle_manager.player.energy))
		return
	for a in selected_cards:
		index_in_deck = a[0]
		res = await battle_manager.player.play_card(index_in_deck)
		if res[0] != int(GameCard.Move.STAY):
			await a[1].tween_scale()
			a[1].visible = false
			hidden_cards.append(a[1])
			occupied.set(a[2],null)
		else:
			if !occupied.get(a[1].last_point):
				occupied.set(a[2],null)
				a[1].current_point = a[1].last_point
				occupied.set(a[1].current_point,a[1])
				if a[1].last_point:
					a[1].dup_point = a[1].last_point
					a[1].tween_to_point(a[1].last_point,0.25)
			else:
				printerr("previous point "+str(a[1].last_point)+" occupied by "+str(occupied.get(a[1].last_point)))
				a[1].visible = false
				hidden_cards.append(a[1])
				var ind = battle_manager.player.hand.find(a[1].index_in_deck)
				battle_manager.player.hand.pop_at(ind)
				battle_manager.player.burn.append(a[1].index_in_deck)
				occupied.set(a[2],null)
	if len(selected_cards) > 0:
		exec_turn()

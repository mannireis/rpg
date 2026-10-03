extends Node

@warning_ignore_start("unused_signal")
signal transition(door: Door)
signal battle_won
signal battle_lost
@warning_ignore_restore("unused_signal")
signal start_battle
func _start_battle() -> void:
	var p = get_tree().current_scene.scene_file_path
	if !GameState.won(GameState.speaking_with):
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = GameState.player_pos
		RoomChangeGlobal.scene_return = p
		GameState.battle_running = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/combat/battle.tscn")
	else: print(GameState.battled_npcs)

func _ready() -> void: start_battle.connect(_start_battle)

class BattleInv:
	var input_deck: Array[Vector2i] ##Array of (suit,id) vectors
	var input_starting_equipped: Array[Vector2i]
	var input_starting_hand: Array[Vector2i]
	var deck: Array[GameCard]
	var starting_equipped: Array[GameCard]
	var starting_hand: Array[GameCard]
	var max_hp := 26
	var hp := max_hp
	var ai_int := 0
	var anim_character: AnimatedSprite2D
	static func convert_to_card(a: Array[Vector2i]) -> Array[GameCard]:
		var res = []
		for i in a:
			res.append(CardDatabase.db[i[0]][i[1]])
		return res
	static func create(max_hp: int = 26,input_deck: Array[Vector2i] = [], input_equipped: Array[Vector2i] = [], input_hand: Array[Vector2i] = [], ai_int: int = 0) -> BattleInv:
		var inv = BattleInv.new()
		inv.max_hp = max_hp
		inv.input_deck = input_deck
		inv.input_starting_equipped = input_equipped
		inv.input_starting_hand = input_hand
		inv.deck = convert_to_card(input_deck)
		print(inv.deck)
		inv.starting_equipped = convert_to_card(input_equipped)
		inv.starting_hand = convert_to_card(input_hand)
		inv.max_hp = max_hp
		inv.hp = max_hp
		inv.ai_int = ai_int
		return inv

extends NPC

func _ready() -> void:
	super()
	
	Signals.battle_won.connect(_on_battle_won)

	var deck: Array[Vector2i] = [
		Vector2i(0, 0), Vector2i(0, 0),
		Vector2i(0, 2), Vector2i(0, 2),
		Vector2i(0, 4), Vector2i(0, 4), Vector2i(0, 4), Vector2i(0, 4), Vector2i(0, 4),
		Vector2i(1, 0), Vector2i(1, 0),
		Vector2i(3, 0), Vector2i(3, 0), Vector2i(3, 0),
		Vector2i(3, 1),
		Vector2i(3, 2),
	]

	var starting_equipped: Array[Vector2i] = [
		Vector2i(3, 1),
	]

	var starting_hand: Array[Vector2i] = []

	var inv: Signals.BattleInv = Signals.BattleInv.create(
		50,
		deck,
		starting_equipped,
		starting_hand
	)

	inv.ai_atk_chance = 0.05
	inv.ai_block_chance = 0.05

	RoomChangeGlobal.enemy_inv_dict[npc_name] = [inv]


func _on_battle_won() -> void:
	GameState.add_card(CardDatabase.db[0][4])

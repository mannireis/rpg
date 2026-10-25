extends NPC

var battle_won := false

func _ready() -> void:
	super()
	Signals.dialogue_branched.connect(_current_id)
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
	battle_won = true


func _current_id(id: String) -> void:
	if GameState.speaking_with != npc_name:
		return
	if id == &"correct" or battle_won:
		met_id = &"met"
		$CollisionShape2D.shape.size.y = 28
		$CollisionShape2D.position.y = 42
		$Area2D.position.y = 15
		$AnimatedSprite2D.play("idle_low")
	if id == &"wrong":
		met_id = &"start"

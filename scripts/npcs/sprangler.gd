extends NPC

var battle_won := false

func _ready() -> void:
	super()
	Signals.dialogue_branched.connect(_current_id)
	Signals.battle_won.connect(_battle_won)

	var deck: Array[Vector2i] = [
		Vector2i(0, 0), Vector2i(0, 0),
		Vector2i(0, 1), Vector2i(0, 1),
		Vector2i(0, 3), Vector2i(0, 3), Vector2i(0, 3), Vector2i(0, 3), Vector2i(0, 3),
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


func _battle_won() -> void:
	if npc_name != GameState.spoke_before_battle: return
	super()
	GameState.add_card(CardDatabase.db[0][3])
	battle_won = true


func _current_id(id: String) -> void:
	if GameState.speaking_with != npc_name:
		return
	if id == &"correct" or battle_won:
		met_id = &"met"
		_set_met_visuals()
	if id == &"wrong":
		met_id = &"start"


func _set_met_visuals() -> void:
	$CollisionShape2D.shape.size.y = 28
	$CollisionShape2D.position.y = 42
	$Area2D.position.y = 15
	$AnimatedSprite2D.play("idle_low")


func save_state() -> Dictionary:
	var state := super()
	state["battle_won"] = battle_won
	return state


func apply_state(state: Dictionary) -> void:
	super(state)
	battle_won = state.get("battle_won", false)
	if battle_won or met_id == &"met":
		_set_met_visuals()

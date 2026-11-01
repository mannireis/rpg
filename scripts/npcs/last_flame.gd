extends NPC

func _current_id(id:String) -> void:
	if GameState.speaking_with != npc_name: return
	if id == "correct_all":
		print("last flame giving healing splash")
		GameState.add_card(CardDatabase.db[2][1])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.dialogue_branched.connect(_current_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

extends NPC

var ran := false
var battle_won := false

func _ready() -> void:
	super()
	DialogueManager.current_id.connect(_current_id)
	Signals.battle_lost.connect(_battle_lost)
	Signals.battle_won.connect(_battle_won)


func _physics_process(delta: float) -> void:
	if GameState.won(npc_name):
		queue_free()

func _current_id(id: String) -> void:
	if GameState.speaking_with == npc_name:
		if id == "end":
			ran = true
		else:
			ran = false


func _battle_lost() -> void:
	battle_won = false
	print("lost battle")
	
	GameState.fought(npc_name, true)
	Signals.battle_won.emit()


func _battle_won() -> void:
	battle_won = true
	print("won battle")

	met_id = &"battle_won"

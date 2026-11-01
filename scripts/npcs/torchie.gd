extends NPC

func _on_bcast(action:String) -> void:
	if action == "torchie_happy":
		$AnimatedSprite2D.animation = &"happy"
		id = &"happy"
		met_id = &"happy"
		
func _current_id(id:String) -> void:
	if GameState.speaking_with != npc_name: return
	if id == "poof":
		print("torchie disappearing")
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.bcast.connect(_on_bcast)
	Signals.dialogue_branched.connect(_current_id)

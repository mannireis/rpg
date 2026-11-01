extends NPC

func _on_bcast(action:String) -> void:
	if action == "torchie_happy":
		$AnimatedSprite2D.animation = &"happy"
		id = &"happy"
		met_id = &"happy"
		autostart_dialogue = false
		
func _current_id(id:String) -> void:
	if GameState.speaking_with != npc_name: return
	if id == "met": diag_start_primed = true
	if id == "poof":
		print("torchie disappearing")
		visible = false
		collision_mask = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.bcast.connect(_on_bcast)
	Signals.dialogue_branched.connect(_current_id)
	area2d.body_entered.connect(diag_start)
	diag_start_primed = true

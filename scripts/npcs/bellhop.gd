extends NPC

const TICKET = preload("res://assets/ticket.tres")

func _ready() -> void:
	super()
	Signals.dialogue_branched.connect(_current_id)


func _physics_process(delta: float) -> void:
	super(delta)
	

func _current_id(id: String) -> void:
	if GameState.speaking_with != npc_name:
		return
	if id == "yes":
		if GameState.item_inventory.has(TICKET):
			print("allowed")
		else:
			print("not allowed")

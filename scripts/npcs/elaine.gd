extends NPC

func _ready() -> void:
	super()
	DialogueManager.current_id.connect(_current_id)


func _physics_process(delta: float) -> void:
	super(delta)
	play_animations(Vector2.ZERO)


func _current_id(id: String) -> void:
	if GameState.speaking_with != npc_name:
		return
	if id == "shop":
		ShopUi.visible = true

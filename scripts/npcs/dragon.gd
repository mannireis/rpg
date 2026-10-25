extends NPC


func _physics_process(delta: float) -> void:
	if GameState.has_met(&"Kira"):
		id = &"met_kira"
	else:
		id = &"start"

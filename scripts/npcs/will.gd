extends NPC
func _ready() -> void:
	area2d.body_entered.connect(diag_start)
	autostart_dialogue = false
	
func diag_start(body: Node2D) -> void:
	if body.is_in_group("player") and not GameState.has_met(npc_name):
		autostart_dialogue = true
		print("trying autostart")
		_unhandled_input(null)

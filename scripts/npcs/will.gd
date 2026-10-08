extends NPC
func _ready() -> void:
	area2d.body_entered.connect(diag_start)
	
func diag_start() -> void:
	autostart_dialogue = true
	

extends NPC
func _ready() -> void:
	area2d.body_entered.connect(diag_start)

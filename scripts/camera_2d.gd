extends Camera2D

@onready var player: Player = $"../Player"


func _process(delta: float) -> void:
	var viewport = get_viewport_rect().size
	position = (player.position - viewport / 2).snapped(viewport)

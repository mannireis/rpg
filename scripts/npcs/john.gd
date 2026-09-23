extends NPC

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if in_range:
		animated_sprite_2d.play("Thinking")
	else:
		animated_sprite_2d.play("Idle")

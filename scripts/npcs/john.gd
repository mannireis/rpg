extends NPC

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	super._on_area_2d_body_entered(body)

	if body is Player:
		animated_sprite.play(&"thinking")


func _on_area_2d_body_exited(body: Node2D) -> void:
	super._on_area_2d_body_exited(body)

	if body is Player:
		animated_sprite.play(&"idle")

@tool
extends Control

@onready var card_texture: TextureRect = $CardTexture

@export var card: CardBase

var dragging = false
var drag_offset = Vector2()

func _process(delta: float) -> void:
	card_texture.texture = card.card_texture


func _gui_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_offset = get_global_mouse_position() - global_position
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


func _on_mouse_entered() -> void:
	scale = Vector2(1.2,1.2)


func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

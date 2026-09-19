@tool
extends Control

@onready var card_texture: TextureRect = $CardTexture
@onready var battle_manager: Node = get_tree().get_root().get_node("BattleManager")
@export var card: CardBase
var index_in_deck: int = -1
var dragging = false
var hovering = false
var drag_offset = Vector2()
var current_point: Control = null


func _ready() -> void:
	card_texture.texture = card.card_texture
	pivot_offset = size / 2

func _process(_delta: float) -> void:
	animate_hovering()


func _gui_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
				if current_point:
					var point_manager = get_parent()
					if point_manager.occupied.get(current_point) == self:
						point_manager.occupied.erase(current_point)
					current_point = null
		else:
			dragging = false
			snap_to_nearest_point()
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset


func snap_to_nearest_point() -> void:
	var point_manager = get_parent()
	var card_center = global_position + size * scale / 2.0
	var target_point = point_manager.get_nearest_point(card_center)
	if target_point:
		if point_manager.occupied.get(target_point) == null:
			hovering = false
			scale = Vector2.ONE
			rotation_degrees = 0.0
			var tween = create_tween()
			tween.tween_property(self, "global_position", target_point.global_position + (target_point.size - size) / 2.0, 0.15)
			point_manager.occupied[target_point] = self
			current_point = target_point
		else:
			current_point = null
			


func animate_hovering() -> void:
	if dragging:
		return
	var tween = create_tween()
	if hovering:
		tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.15)
		tween.parallel().tween_property(self, "rotation_degrees", 15.0, 0.15)
	else:
		tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
		tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.15)

func _on_mouse_short_click() -> void:
	pass


func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false

@tool
extends Node2D

const _COLOR = Color(1, 1, 1, 0.2)

var _viewport := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)
var _editor_viewport: Rect2


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	var viewport := EditorInterface.get_editor_viewport_2d()
	var editor_viewport := viewport.global_canvas_transform.affine_inverse() * Rect2(Vector2.ZERO, viewport.size)

	if editor_viewport != _editor_viewport:
		_editor_viewport = editor_viewport
		queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var cells := Vector2i(_editor_viewport.size / _viewport)

	for row in range(-1, cells.y + 1):
		var y := _editor_viewport.position.snapped(_viewport).y + row * _viewport.y
		var x_from := _editor_viewport.position.x
		var x_to := _editor_viewport.end.x
		draw_line(Vector2(x_from, y), Vector2(x_to, y), _COLOR)

	for column in range(-1, cells.x + 1):
		var x := _editor_viewport.position.snapped(_viewport).x + column * _viewport.x
		var y_from := _editor_viewport.position.y
		var y_to := _editor_viewport.end.y
		draw_line(Vector2(x, y_from), Vector2(x, y_to), _COLOR)

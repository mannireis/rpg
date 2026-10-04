extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var size: int = 2
@export var buttons: Array[Button2D]


func _ready() -> void:
	for button in buttons:
		button.toggled.connect(_on_button_toggled)


func _physics_process(delta: float) -> void:
	collision_shape_2d.shape = $CollisionShape2D.shape.duplicate()
	collision_shape_2d.shape.size = Vector2(16, size * 16)
	$Sprite2D.scale = Vector2(1, size)


func _on_button_toggled(is_on: bool) -> void:
	if buttons.all(func(b: Button2D) -> bool: return b.is_on):
		open()
	else:
		close()


func open() -> void:
	print("open")
	collision_shape_2d.set_deferred("disabled", true)
	$Sprite2D.modulate.a = 0.5


func close() -> void:
	print("closed")
	collision_shape_2d.set_deferred("disabled", false)
	$Sprite2D.modulate.a = 1.0

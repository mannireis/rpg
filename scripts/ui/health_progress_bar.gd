class_name HealthBar2D
extends Panel

@onready var _shield_progress_bar: ProgressBar = %ShieldProgressBar
@onready var _health_progress_bar: ProgressBar = %HealthProgressBar

@export_range(0, 32, 1) var health_value: int = 32
@export_range(0, 32, 1) var shield_value: int = 0

func _ready() -> void:
	for bar in [_shield_progress_bar, _health_progress_bar]:
		bar.value = bar.max_value
		bar.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		bar.add_theme_stylebox_override("background", StyleBoxEmpty.new())


func _process(_delta: float) -> void:
	_shield_progress_bar.custom_minimum_size.y = shield_value
	_health_progress_bar.custom_minimum_size.y = health_value

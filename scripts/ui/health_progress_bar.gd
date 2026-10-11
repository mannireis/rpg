class_name HealthBar2D
extends Panel

@onready var shield_progress_bar: ProgressBar = %ShieldProgressBar
@onready var health_progress_bar: ProgressBar = %HealthProgressBar

@export_range(0, 1, 0.1) var health_value: float = 0.0
@export_range(0, 1, 0.1) var shield_value: float = 0.0

func _ready() -> void:
	for bar in [shield_progress_bar, health_progress_bar]:
		bar.value = bar.max_value
		bar.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		bar.add_theme_stylebox_override("background", StyleBoxEmpty.new())


func _process(_delta: float) -> void:
	shield_progress_bar.custom_minimum_size.y = shield_value * 32
	health_progress_bar.custom_minimum_size.y = health_value * 32

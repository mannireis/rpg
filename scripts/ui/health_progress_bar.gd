class_name HealthBar2D
extends Panel

signal damaged(amount: float)

@onready var _sfx: AudioStreamPlayer = %AudioStreamPlayerSFX
@onready var _shield_progress_bar: ProgressBar = %ShieldProgressBar
@onready var _health_progress_bar: ProgressBar = %HealthProgressBar
@onready var _fire_progress_bar: ProgressBar = %FireProgressBar

@export_range(0, 32, 1) var health_value: float = 32
@export_range(0, 32, 1) var shield_value: float = 0
@export_range(0,31,1) var fire_value: float = 0

var target_health := 32.0:
	set(value):
		if value == target_health: return
		var lost := value < target_health
		if lost:
			damaged.emit(target_health - value)
		target_health = value
		_play_damage_sound(lost)

var target_shield := 0.0:
	set(value):
		if value == target_shield: return
		target_shield = value
		_play_damage_sound(false)

var target_fire := 0.0:
	set(value):
		if value == target_fire: return
		target_fire = value
func _ready() -> void:
	for bar in [_shield_progress_bar, _health_progress_bar,_fire_progress_bar]:
		bar.value = bar.max_value
		bar.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		bar.add_theme_stylebox_override("background", StyleBoxEmpty.new())


func _process(delta: float) -> void:
	var t := 1.0 - exp(-10.0 * delta)
	
	health_value = lerpf(health_value, target_health, t)
	shield_value = lerpf(shield_value, target_shield, t)
	fire_value = lerpf(fire_value, target_fire, t)
	
	_shield_progress_bar.custom_minimum_size.y = shield_value
	_health_progress_bar.custom_minimum_size.y = health_value
	_fire_progress_bar.custom_minimum_size.y = fire_value
	#if fire_value > 0 and _fire_progress_bar.custom_minimum_size.y >2: print("fire min size "+str(_fire_progress_bar.custom_minimum_size))
	var _firepos = _fire_progress_bar.position
	_firepos = Vector2(_firepos.x,_health_progress_bar.position.y-health_value+fire_value)


func _play_damage_sound(is_damage: bool) -> void:
	if is_damage:
		_sfx.stream = preload("res://assets/audio/damage.wav") 
	else:
		_sfx.stream = preload("res://assets/audio/healup.wav") 
	
	_sfx.pitch_scale = randf_range(0.9, 1.1)
	_sfx.play()

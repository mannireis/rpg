extends Control

@export var max_value: float = 6.0
@export var o_speed: float = 0.5  # units per second
@export var x_speed: float = 0.5

var o: float = 0.0
var x: float = 0.0

@onready var back: ProgressBar = $ProgressBar    # X
@onready var front: ProgressBar = $ProgressBar2  # O

func _ready() -> void:
	back.max_value = max_value
	front.max_value = max_value

func _process(delta: float) -> void:
	o = minf(o + o_speed * delta, max_value)
	x = minf(x + x_speed * delta, max_value - o)

	front.value = o
	back.value = o + x

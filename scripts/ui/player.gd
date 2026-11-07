extends CanvasLayer

@onready var label: Label = $MarginContainer/InteractLabel

func _ready() -> void:
	label.hide()


func _process(_delta: float) -> void:
	if GameState.dialoguing:
		label.hide()

extends CanvasLayer

@onready var interact_label: Label = $MarginContainer/InteractLabel

func _ready() -> void:
	hide_label()


func _process(delta: float) -> void:
	if DialogueManager.active:
		hide_label()


func hide_label() -> void:
	interact_label.visible = false


func unhide_label() -> void:
	interact_label.visible = true

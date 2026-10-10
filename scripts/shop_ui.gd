extends CanvasLayer

@onready var grid_container: GridContainer = $MarginContainer/HBoxContainer/PanelContainer/GridContainer
@onready var card_name: Label = $MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/CardName
@onready var card_description: Label = $MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/CardDescription
@onready var h_separator: HSeparator = $MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/HSeparator


func _ready() -> void:
	visible = false
	
	for child in grid_container.get_children():
		if child as ShopItem:
			child.mouse_entered.connect(_show_info.bind(child, true))
			child.mouse_exited.connect(_show_info.bind(child, false))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"pause_game"):
		visible = false


func _show_info(item: ShopItem, active: bool) -> void:
	item.offset_transform_enabled = true
	item.offset_transform_position = Vector2.ONE if active or item.disabled else Vector2.ZERO
	
	if active and not item.disabled:
		card_name.text = item.card_name
		card_description.text = item.card_description
	elif item.disabled:
		card_name.visible = false
		card_description.visible = false 
		h_separator.visible = false
	
	if not item.disabled:
		card_name.visible = active
		card_description.visible = active 
		h_separator.visible = active

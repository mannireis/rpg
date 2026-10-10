class_name ShopItem
extends Button

@export var suit: GameCard.S = GameCard.S.SPADES
@export var index: int = 0

var card: GameCard
var card_name := ""
var card_description := ""

func _ready() -> void:
	button_down.connect(_on_pressed)
	card = CardDatabase.db[suit][index]
	card_name = card.name
	card_description = card.text
	icon = card.img


func _on_pressed() -> void:
	print("pressed!")
	disabled = true
	GameState.add_card(card)

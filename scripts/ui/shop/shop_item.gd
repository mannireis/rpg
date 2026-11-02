class_name ShopItem
extends Button

@export var suit: GameCard.S = GameCard.S.SPADES
@export var index: int = 0

var card: GameCard
var card_name := ""
var card_description := ""

func _ready() -> void:
	button_down.connect(_on_pressed)
	add_to_group("saveable")
	_refresh_card()


func _refresh_card() -> void:
	var cards := CardDatabase.db[suit]
	index = clampi(index, 0, cards.size() - 1)
	card = cards[index]
	card_name = card.name
	card_description = card.text
	icon = card.img


func save_id() -> String:
	return String(name)


func save_state() -> Dictionary:
	return {
		"suit": int(suit),
		"index": index,
		"disabled": disabled
	}


func apply_state(state: Dictionary) -> void:
	suit = state.get("suit", suit) as GameCard.S
	index = int(state.get("index", index))
	disabled = bool(state.get("disabled", disabled))
	_refresh_card()


func _on_pressed() -> void:
	print("pressed!")
	disabled = true
	GameState.add_card(card)

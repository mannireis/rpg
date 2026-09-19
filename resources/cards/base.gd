class_name CardBase
extends Resource

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export_category("Values")
@export var card_color: GameCard.S
@export var card_id: int
@export var card_texture: Texture2D 
@export var rarity: Rarity = Rarity.COMMON
@export var is_enemy: bool = false
var card_data: GameCard = CardDatabase.db[int(card_color)][card_id]
var cost: int = card_data.cost
var card_name = card_data.name
var description: String = card_data.text

func use(user: Node, targets: Array) -> void: pass

class_name CardBase
extends Resource

enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

@export_category("Values")
@export var card_name: String
@export var card_id: StringName
@export var card_texture: Texture2D 
@export var rarity: Rarity = Rarity.COMMON
@export_multiline var description: String
@export_range(0, 6) var cost: int = 1


func use(user: Node, targets: Array) -> void: pass

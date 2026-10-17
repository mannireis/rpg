@tool
class_name PressurePlate
extends Node2D

signal _pressed(pressed: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_enum("Diamonds", "Spades", "Hearts", "Clubs") var house: int = 0
@export var other_preasure_plates: Array[PressurePlate]
@export var password: int

var bodies_on_preasure_plate := 0


func _ready() -> void:
	for p in other_preasure_plates:
		p.other_preasure_plates = other_preasure_plates
	
	sprite_2d.region_rect.position.y = 32
	sprite_2d.region_rect.position.x = house * 16


func _on_area_2d_body_entered(body: Node2D) -> void:
	bodies_on_preasure_plate += 1
	if bodies_on_preasure_plate >= 1:
		sprite_2d.region_rect.position.y = 48
		_pressed.emit(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_on_preasure_plate -= 1
	if bodies_on_preasure_plate <= 0:
		sprite_2d.region_rect.position.y = 32
		_pressed.emit(false)

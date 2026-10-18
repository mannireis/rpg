@tool
class_name PressurePlate
extends Node2D

signal pressed(pressed: bool)
signal correct_password

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var house: House = House.DIAMONDS
@export var other_preasure_plates: Array[PressurePlate]
@export var password: Array[int]

var bodies_on_preasure_plate := 0
var _typed_password: Array[int]

enum House{
	DIAMONDS,
	SPADES,
	HEARTS,
	CLUBS
}


func _ready() -> void:
	for p in other_preasure_plates:
		p.other_preasure_plates = other_preasure_plates
		p.password = password
	
	sprite_2d.region_rect.position.y = 32
	sprite_2d.region_rect.position.x = house * 16


func _physics_process(delta: float) -> void:
	for p in other_preasure_plates:
		p._typed_password = _typed_password


func _on_area_2d_body_entered(body: Node2D) -> void:
	bodies_on_preasure_plate += 1
	
	_typed_password.append(house + 1)

	if _typed_password == password:
		print("correct!")
		correct_password.emit()
		_typed_password.clear()
		correct_password.emit()
	elif _typed_password.size() >= password.size():
		print("WRONG :<<<<<")
		_typed_password.clear()

	print(_typed_password)
	if bodies_on_preasure_plate >= 1:
		sprite_2d.region_rect.position.y = 48
		pressed.emit(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_on_preasure_plate -= 1
	if bodies_on_preasure_plate <= 0:
		sprite_2d.region_rect.position.y = 32
		pressed.emit(false)


func _on__correct_password() -> void:
	pass # Replace with function body.

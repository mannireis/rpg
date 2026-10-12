extends CharacterBody2D

var active := false
signal passersby_appear
signal passersby_die

func _ready() -> void:
	passersby_appear.connect(appear)
	passersby_die.connect(die)

func appear() -> void:
	active = true
	visible = true
	velocity = Vector2i(40,10)
	print("hello")
	
func die() -> void:
	velocity = Vector2i(0,0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D,"scale",Vector2(0.25,0.25),0.5)
	active = false
	await get_tree().create_timer(0.5).timeout
	visible = false
	

func _physics_process(_delta: float) -> void:
	if active: move_and_slide()

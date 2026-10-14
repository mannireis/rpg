extends CharacterBody2D

var active := false
var retarget: SceneTreeTimer
var last_correction: Vector2 = Vector2(0,0)
var last_aim := Vector2(-4,4)
signal passersby_appear
signal passersby_die
@export var vel: Vector2i
@export var vel_scale: float = 15
@export var target: Node2D

func _ready() -> void:
	passersby_appear.connect(appear)
	passersby_die.connect(die)
	var area2d = $Area2D
	area2d.body_entered.connect(_on_body_entered)
	retarget = get_tree().create_timer(0.5)
	retarget.timeout.connect(_on_retarget)
	last_aim *= vel_scale

func vel_to_target() -> Vector2:
	if target:
		var res: Vector2 = Vector2(0,0)
		res += (last_aim+last_correction)
		var vec = target.global_position-global_position
		var norm = vec.normalized()
		last_aim = norm*(vel_scale)
		last_correction = Vector2.from_angle(norm.angle())*(vel_scale/12)
		res += (last_aim+last_correction)
		res /= 2
		return res
	else: return velocity
	
func _on_retarget() -> void:
	velocity = vel_to_target()
	retarget = get_tree().create_timer(0.1)
	retarget.timeout.connect(_on_retarget)
	

func appear() -> void:
	active = true
	visible = true
	velocity = vel*vel_scale
	if target: velocity = last_aim
	
func die() -> void:
	velocity = Vector2i(0,0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D,"scale",Vector2(0.25,0.25),0.6)
	active = false
	await get_tree().create_timer(0.6).timeout
	visible = false
	
func explode() -> void:
	velocity = Vector2i(0,0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D,"scale",Vector2(1.5,1.5),0.3)
	active = false
	await get_tree().create_timer(0.3).timeout
	visible = false

func _on_body_entered(node: Node2D) -> void:
	if node.is_in_group("fireball") and node != self:
		await node.explode()
		die()

func _physics_process(_delta: float) -> void:
	if active: move_and_slide()

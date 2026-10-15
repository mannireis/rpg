class_name Player
extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float = 70.0
@export var friction : float = 1000.0
var render_fix_moved := false
var last_dir := Vector2.DOWN
var intended_velocity := Vector2.ZERO

func _ready() -> void:
	add_to_group("player")
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		RoomChangeGlobal.activate = false
	if RoomChangeGlobal.emit_battle:
		RoomChangeGlobal.emit_battle = false
		if RoomChangeGlobal.last_battle_result: Signals.battle_won.emit()
		else: Signals.battle_lost.emit()
	$Timer.timeout.connect(_render_fix)
	$Timer.start()

func _physics_process(delta: float) -> void:
	if DialogueManager.active:
		return

	var direction : Vector2
	
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction:
		velocity = speed * direction.normalized()
		render_fix_moved = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	intended_velocity = velocity
	if Input.is_action_just_pressed("Teleport"):
		global_position = get_tree().get_root().get_node("Chapter01/ProcessModeReset/DevTeleport").global_position
	GameState.player_pos = global_position
	
	play_animations(direction)
	if move_and_slide():
		resolve_collisions()

func _render_fix() -> void: ## Round position to whole pixels to avoid weird rendering
	if !render_fix_moved: global_position = Vector2(round(global_position.x),round(global_position.y))
	else: render_fix_moved = false
func _process(_delta): _render_fix()

func play_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		last_dir = direction
		if abs(direction.x) > abs(direction.y):
			animation.play("walk_right" if direction.x > 0 else "walk_left")
		else:
			animation.play("walk_down" if direction.y > 0 else "walk_up")
	else:
		if abs(last_dir.x) > abs(last_dir.y):
			animation.play("idle_right" if last_dir.x > 0 else "idle_left")
		else:
			animation.play("idle_down" if last_dir.y > 0 else "idle_up")

func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as PushableBlock2D
		if body:
			body.apply_impact(intended_velocity)

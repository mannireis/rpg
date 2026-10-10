extends NPC

@export var follow_speed: float = 0.083

var ran := false
var follow := false
var path: PathFollow2D
var goodbye := false
var _prev_pos: Vector2
var inv: Signals.BattleInv

func _ready() -> void:
	super()
	path = get_parent() as PathFollow2D
	DialogueManager.current_id.connect(_current_id)
	Signals.battle_lost.connect(_battle_lost)
	Signals.battle_won.connect(_battle_won)
	inv = Signals.BattleInv.create(30,[],[Vector2i(3,3)],[Vector2i(3,3)])
	inv.ai_atk_chance = 0.5
	inv.ai_block_chance = 0.3
	RoomChangeGlobal.enemy_inv_dict[npc_name] = inv


func _physics_process(delta: float) -> void:
	if goodbye:
		queue_free()
		return
	if follow and path.progress_ratio <= 1.0:
		path.progress += follow_speed * delta
		
	var moved := global_position - _prev_pos
	_prev_pos = global_position
	
	var direction := Vector2.DOWN
	
	if moved.length() > 0.01:
		direction = moved.normalized()
	
	play_animations(direction)


func _current_id(id: String) -> void:
	if GameState.speaking_with != npc_name:
		return
	if id == "run":
		ran = true
	elif id == "follow":
		follow = true
		met_id = "frens"
	elif id =="dont_follow":
		goodbye = true
	else:
		ran = false


func _battle_lost() -> void:
	print("lost battle")
	
	GameState.fought(npc_name, false)

func _battle_won() -> void:
	print("won battle")
	
	met_id = &"battle_won"
	GameState.fought(npc_name, true)

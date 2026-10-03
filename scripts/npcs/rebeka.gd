extends NPC

@export var follow_speed: float = 0.083

var ran := false
var follow := false
var path: PathFollow2D
var goodbye := false

func _ready() -> void:
	super()
	path = get_parent()
	DialogueManager.current_id.connect(_current_id)
	Signals.battle_lost.connect(_battle_lost)
	Signals.battle_won.connect(_battle_won)


func _physics_process(delta: float) -> void:
	if follow:
		path.progress += follow_speed * delta
	elif goodbye:
		queue_free()

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

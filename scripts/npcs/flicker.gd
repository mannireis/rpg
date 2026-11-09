extends NPC

var first_seen := false
var room_door: Door

func v(a: int, b: int = 0) -> Vector2i: 
	return Vector2i(a,b)


func _ready() -> void:
	var base: Array[Vector2i] = [v(0,2),v(0,2),v(0,2),v(0,2),v(0,2),v(0,2),v(0,2),v(0,2),v(3,4),v(1,0),v(1,0),v(0,0),v(0,0)]
	var deck := base
	var deck2 := base
	var doors = get_tree().get_root().get_node("Chapter01/Doors")
	room_door = doors.get_node("Door43")

	deck.append_array([v(1,0),v(1,0),v(0,1),v(0,1),v(0,1),v(3,4)])
	var inv = Signals.BattleInv.new(24,deck,[],[v(1,0),v(0,2)])
	#inv.ai_atk_chance = 0.25
	inv.ai_atk_chance = 0
	inv.ai_block_chance = 0.15
	inv.ai_int = 1
	inv.energy = 6
	
	deck2.append_array([v(0,0),v(0,0),v(3,1),v(3,1),v(0,2)])
	var inv2 = Signals.BattleInv.new(26,deck2,[],[v(0,2),v(0,2),v(3,4)]) ## "smarter" Flicker
	inv2.ai_atk_chance = 0.2
	inv2.ai_block_chance = 0.1
	inv2.ai_int = 1
	inv2.energy = 6

	RoomChangeGlobal.enemy_inv_dict[npc_name] = [inv,inv2]

	Signals.transition.connect(room_entered)
	Signals.battle_lost.connect(_battle_lost)
	Signals.battle_won.connect(_battle_won)
	#print(room_door.body_entered.get_connections())


func save_state() -> Dictionary:
	var state := super()
	state["first_seen"] = first_seen
	return state


func apply_state(state: Dictionary) -> void:
	super(state)
	first_seen = state.get("first_seen", false)


func room_entered(door: Door) -> void: # make the passersby creature appear when the player first enters flicker's room
	pass
	if door != room_door:
		return

	print(str(door)+", "+str(door.get_groups())+" entered flicker's room. seen? "+str(first_seen))
	if !first_seen:
		first_seen = true
		get_parent().get_node("ThePassersby").appear()
		await get_tree().create_timer(1).timeout
		var f = get_node("FireballBullet")
		f.get_node("AnimatedSprite2D").play("fireball")
		f.add_to_group("fireball")
		get_node("FireballBullet").appear()
func _battle_lost() -> void:
	if GameState.spoke_before_battle != npc_name: return
	super()
	print("flicker battle lost")
	met_id = &"battle_lost"

func _battle_won() -> void:
	if GameState.spoke_before_battle != npc_name: return
	super()
	print("flicker battle won")
	met_id = &"battle_won"
		

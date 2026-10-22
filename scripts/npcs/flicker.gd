extends NPC

var first_seen := false


func v(a:int, b:int = 0) -> Vector2i: return Vector2i(a,b)


func _ready() -> void:
	var base: Array[Vector2i] = [v(0,2),v(0,2),v(1,0),v(1,0),v(1,0),v(1,0),v(1,0),v(1,0),v(0,0),v(0,0),v(0,0),v(0,0),v(0,0)]
	var deck := base
	var deck2 := base
	var inv = Signals.BattleInv.create(20,deck,[],[v(0,3),v(0,3)])
	var inv2 = Signals.BattleInv.create(22,deck2,[],[v(0,3),v(0,3)]) ## "smarter" Flicker
	var doors = get_tree().get_root().get_node("Chapter01/ProcessModeReset/YSort/Doors")
	var door34: Door = doors.get_node("Door34")

	deck.append_array([v(1,0),v(1,0),v(0,1),v(0,1),v(0,1)])

	inv.ai_atk_chance = 0.25
	inv.ai_block_chance = 0.15
	
	deck2.append_array([v(0,0),v(0,0),v(3,1),v(3,1),v(0,3)])

	inv2.ai_atk_chance = 0.2
	inv2.ai_block_chance = 0.1

	RoomChangeGlobal.enemy_inv_dict[npc_name] = [inv,inv2]

	door34.body_entered.connect(room_entered)
	print(door34.body_entered.get_connections())


func room_entered(body: Node2D) -> void: # make the passersby creature appear when the player first enters flicker's room
	print(str(body)+", "+str(body.get_groups())+" entered flicker's room. seen? "+str(first_seen))
	if body.is_in_group("player") and !first_seen:
		first_seen = true
		get_parent().get_node("ThePassersby").appear()
		await get_tree().create_timer(1).timeout
		var f = get_node("FireballBullet")
		f.get_node("AnimatedSprite2D").play("fireball")
		f.add_to_group("fireball")
		get_node("FireballBullet").appear()
		

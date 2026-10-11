extends NPC
func v(a:int, b:int = 0) -> Vector2i: return Vector2i(a,b)
func _ready() -> void:
	var base: Array[Vector2i] = [v(0,2),v(0,2),v(1,0),v(1,0),v(1,0),v(1,0),v(1,0),v(1,0),v(0,0),v(0,0),v(0,0),v(0,0),v(0,0)]
	var deck := base
	var deck2 := base
	deck.append_array([v(1,0),v(1,0),v(0,1),v(0,1),v(0,1)])
	var inv = Signals.BattleInv.create(20,deck,[],[v(0,3),v(0,3)])
	inv.ai_atk_chance = 0.25
	inv.ai_block_chance = 0.15
	deck2.append_array([v(0,0),v(0,0),v(3,1),v(3,1),v(0,3)])
	var inv2 = Signals.BattleInv.create(22,deck2,[],[v(0,3),v(0,3)])
	inv2.ai_atk_chance = 0.2
	inv2.ai_block_chance = 0.1
	RoomChangeGlobal.enemy_inv_dict[npc_name] = [inv,inv2]

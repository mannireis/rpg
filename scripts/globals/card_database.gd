class_name CardList
extends Node

const n = GameCard.Able.NONE
const s = GameCard.S
const v0 = Vector2i(0,0)
const p = "res://assets/aseprite/cards/"

var common_textures: Array[Texture2D] = [
	preload(p+"bad_card.png")
]

var db: Array[Array] = [
[GameCard.create(s.SPADES, 0, n, v0, "Double Trouble", 1, preload(p+"0/0.png",), "test"),
GameCard.create(s.SPADES,1,n,Vector2i(10,0),"Barbaric Strike",2,preload(p+"0/1.png"), "test"),
GameCard.create(s.SPADES,2,n,Vector2i(1,0),"Poke",0,preload(p+"0/2.png"), "test")],
[GameCard.create(s.CLUBS,0,n,v0,"Good Posture",1,preload(p+"1/0.png"), "test")],
[GameCard.create(s.HEARTS,0,n,Vector2i(2,0),"Disarm Equipment",2,preload(p+"2/0.png"),"eat the opponent's cards at a cost")],
[GameCard.create(s.DIAMONDS,0,GameCard.Able.ATK,Vector2i(5,0),"Pirate Saber",2,preload(p+"3/0.png"), "test"),
GameCard.create(s.DIAMONDS,1,GameCard.Able.BLOCK,Vector2i(-5,0),"Sturdy Shield",2,preload(p+"3/1.png"), "test"),
GameCard.create(s.DIAMONDS,2,n,Vector2i(2,0),"Abstract Art",2,preload(p+"3/2.png"), "test"),
GameCard.create(s.DIAMONDS,3,GameCard.Able.ATK,Vector2i(8,0),"Rebeka's Halberd",3,preload(p+"3/3.png"), "Pretty, isn't it?")],
[],
[GameCard.create(s.OTHER,0,GameCard.Able.ATK,Vector2i(3,0),"Punch",0),
GameCard.create(s.OTHER,0,GameCard.Able.BLOCK,Vector2i(-3,0),"Block",0)]]

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(typeof(db[0][0].play))
	db[0][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.player_attack() #glorious impl of a dual punch
		ctl.player_attack()
		return [GameCard.Move.TRASH]
	db[0][1].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.exec_atk(db[0][1].atk)
		if _enemy_ctl.hp > 0:
			_enemy_ctl.exec_atk(Vector2i(4,0))
		return [GameCard.Move.TRASH]
	db[0][2].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.exec_atk(db[0][2].atk)
		return [GameCard.Move.STAY]
		
		
	db[1][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		ctl.player_attack(true)
		ctl.player_attack(true)
		return [GameCard.Move.TRASH]
		
		
	db[2][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		if !ctl.is_enemy:
			ctl.sp.sel_count = 2
			ctl.sp.sel_autosubmit = true
			print(ctl.sp.sel_cards)
			ctl.sp.sel_cards = []
			Input.set_custom_mouse_cursor(preload(p+"../../select_cursor.png"))
			await ctl.sp.cards_selected
			var vcsel = ctl.sp.sel_cards
			print("cards selected "+str(vcsel))
			for vc in vcsel:
				ctl.hand.erase(vc.index_in_deck)
				ctl.burn.append(vc.index_in_deck)
				ctl.sp.occupied.set(vc.current_point,null)
				ctl.sp.hidden_cards.append(vc)
				vc.tween_scale(0.5)
				vc.visible = false
			var num_eq := len(_enemy_ctl.equipped)
			_enemy_ctl.equipped = []
			_enemy_ctl.equipped_cards = []
			for child in _enemy_ctl.equipped_display.get_children():
				child.texture = null
			for i in range(num_eq+1): ctl.exec_atk(db[2][0].atk)
		return [GameCard.Move.TRASH]
	
	
	db[3][0].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		if db[3][0] not in ctl.equipped_cards and len(ctl.equipped_cards) < 3:
			print("equipping "+self.name)
			return [GameCard.Move.EQUIP]
		else:
			ctl.exec_atk(Vector2i(6,0))
			return [GameCard.Move.TRASH]
	db[3][1].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		if db[3][1] not in ctl.equipped_cards and len(ctl.equipped_cards) < 3:
			print("equipping "+self.name)
			return [GameCard.Move.EQUIP]
		else:
			ctl.exec_block(Vector2i(-6,0))
			return [GameCard.Move.TRASH]
	db[3][2].play = func(ctl: PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		if db[3][2] not in ctl.equipped_cards and len(ctl.equipped_cards) < 3:
			return [GameCard.Move.EQUIP]
		else:
			return [GameCard.Move.TRASH]
	db[3][2].mod_dmg_in = func(dmg: Vector2i,_ctl:PlayerCtl,_enemy_ctl:PlayerCtl):
		if dmg[1] == 0:
			return Vector2i(dmg[0]-1,0)
		else: return dmg
	db[3][2].turn_end = func(_null,_ctl:PlayerCtl,_enemy_ctl:PlayerCtl):
		_ctl.block_accumulator[-1][0] -= 2
	db[3][3].play = func(ctl:PlayerCtl,_enemy_ctl:PlayerCtl) -> Array:
		if db[3][3] not in ctl.equipped_cards: return [GameCard.Move.EQUIP]
		else:
			ctl.exec_atk(Vector2i(db[3][3].atk[0],1))
			return [GameCard.Move.TRASH]

extends Node

var activate: bool = false
var scene_return: String #when a battle finishes, this is where the player should return
var player_pos: Vector2
var player_hp: int
var last_battle_result: bool
var emit_battle: bool = false
var enemy_battle_inventory: Signals.BattleInv = null ## Loaded before battle from enemy_inv_dict by Signals._start_battle()
var enemy_inv_dict: Dictionary[StringName,Array] = {}

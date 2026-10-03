extends Node

var activate: bool = false
var scene_return: String #when a battle finishes, this is where the player should return
var player_pos: Vector2
var player_hp: int
var last_battle_result: bool
var emit_battle: bool = false
var scenes_battle_completed: Array[String] = []

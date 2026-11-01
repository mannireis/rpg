class_name Save
extends Resource

@export var room: String = "res://scenes/chapters/chapter_01.tscn"
@export var chapter_title: String = "Chapter 1"
@export var player_name: String = "Emily"
@export var player_pos: Vector2
@export var play_time: float = 0.0
@export var met_npcs: Dictionary = {}
@export var battled_npcs: Dictionary = {}
@export var defeated_npcs: Dictionary = {}
@export var item_paths: Array[String] = []
@export var deck: Array[Vector2i] = []
@export var max_hp: int = 26
@export var hp: int = 26
@export var world_state: Dictionary = {}

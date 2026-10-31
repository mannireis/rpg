extends Node

const SAVE_PATH = "user://save.tres"
var save := load(SAVE_PATH) as Save if ResourceLoader.exists(SAVE_PATH) else Save.new()


func save_game(slot: int) -> void:
	ResourceSaver.save(save, SAVE_PATH + "_" + str(slot))


func load_game(slot: int) -> void:
	pass

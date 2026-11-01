extends Button

@onready var player_name: Label = $MarginContainer/HBoxContainer/VBoxContainer/PlayerName
@onready var time_played: Label = $MarginContainer/HBoxContainer/VBoxContainer/InfoHBox/TimePlayed
@onready var separator: Label = $MarginContainer/HBoxContainer/VBoxContainer/InfoHBox/Separator
@onready var current_chapter: Label = $MarginContainer/HBoxContainer/VBoxContainer/InfoHBox/CurrentChapter


func refresh(slot: int) -> void:
	if SaveManager.has_save(slot):
		var data := load(SaveManager.slot_path(slot)) as Save
		current_chapter.show()
		player_name.text + data.player_name
		time_played.text = "1h 5m"
		current_chapter.text = data.chapter_title
	else:
		player_name.text = "New Game"
		time_played.text = "0m"
		current_chapter.hide()

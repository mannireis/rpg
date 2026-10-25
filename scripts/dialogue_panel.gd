extends CanvasLayer

const LETTER_TIME:float = 0.04
const PUNCTUATION_TIME:float = 0.3

var tween: Tween
var dialogue_index: int = 0

var _parsed_dialogue: Dictionary = {}
var _current_id := ""
var _current_line := 0

@onready var panel: PanelContainer = $MarginContainer/PanelContainer
@onready var speaker: Label = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Speaker
@onready var content: RichTextLabel = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Content
@onready var choices: VBoxContainer = $MarginContainer/PanelContainer/HBoxContainer/Choices


func _ready():
	Signals.dialogue_started.connect(_on_dialogue_started)


func _on_dialogue_started(file: String, at: StringName) -> void:
	if not FileAccess.file_exists(file):
		push_error("Dialogue file missing in export (check export_presets include_filter): %s" % file)
		DialogueManager.active = false
		_end()
		return
	var txt := FileAccess.get_file_as_string(file)
	if txt.is_empty():
		push_error("Dialogue file empty or failed to load: %s" % file)
		DialogueManager.active = false
		_end()
		return
	_parsed_dialogue = _parse(txt)
	DialogueManager.active = true
	_goto(at)


func _parse(source: String) -> Dictionary:
	var parsed_dialogue := {}
	var lines := source.split("\n")
	var current: Array = []
	var current_id := ""

	for line in lines:
		line = line.strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue

		if line.begins_with("==="):
			var block_id := line.trim_prefix("===").strip_edges().to_lower()
			if block_id == "":
				if current_id != "":
					parsed_dialogue[current_id] = current
				current_id = ""
				current = []
			else:
				current_id = block_id
				current = []
		elif current_id != "":
			if line.begins_with(">>"):
				current.append({"goto": line.trim_prefix(">>").strip_edges().to_lower()})
			elif line.begins_with("*") and line.contains("->"):
				if current.is_empty():
					push_warning("Choice outside a speaker line: " + line)
					continue
				var choice_parts := line.trim_prefix("*").split("->", true, 1)
				current[-1]["choices"].append({
					"text": choice_parts[0].strip_edges(),
					"next": choice_parts[1].strip_edges().to_lower(),
				})
			elif line.contains(":"):
				var parts := line.split(":", true, 1)
				current.append({
					"speaker": parts[0].strip_edges(),
					"text": parts[1].strip_edges(),
					"choices": [],
				})

	return parsed_dialogue


func _goto(id: String) -> void:
	Signals.dialogue_branched.emit(id)
	if id.begins_with("battle_init"):
		var parts := id.split("[", true, 1)
		if parts.size() < 2:
			push_error("battle_init needs an index, e.g. battle_init[0]")
			_end()
			return
		var inv := parts[1].replace("]", "").strip_edges()
		if inv.is_valid_int():
			Signals.start_battle.emit(int(inv))
		else:
			push_error("Warning (" + inv + ") is not a valid int")
		_end()
		return
	if id == "end" or not _parsed_dialogue.has(id):
		_end()
		return

	_current_id = id
	_current_line = 0
	_show_line()


func _show_line() -> void:
	var block: Array = _parsed_dialogue.get(_current_id, [])
	if _current_line >= block.size():
		_end()
		return
	var line = block[_current_line]
	if line.has("goto"):
		_goto(line["goto"])
		return
	_on_line(line)


func advance() -> void:
	_current_line += 1
	if _current_line >= _parsed_dialogue[_current_id].size():
		_end()
	else:
		_show_line()


func choose(target: String) -> void:
	if target == "":
		advance()
	else:
		_goto(target)


func _end() -> void:
	DialogueManager.active = false
	hide()


func _on_line(line: Dictionary) -> void:
	show()
	speaker.text = line["speaker"]
	say(line["text"])

	for c in choices.get_children():
		c.queue_free()

	for c in line["choices"]:
		var b := Button.new()
		b.mouse_filter = Control.MOUSE_FILTER_STOP


		b.theme = load("res://scenes/ui/themes/theme.tres")

		b.text = c["text"]
		b.pressed.connect(choose.bind(c["next"]))
		choices.add_child(b)


func _unhandled_input(event: InputEvent) -> void:
	if not (event.is_action_pressed("Interact") or event.is_action_pressed("next")):
		return

	if tween and tween.is_running():
		tween.kill()
		content.visible_characters = -1
	elif content.visible and choices.get_child_count() == 0:
		advance()
		get_viewport().set_input_as_handled()


func say(text:String):
	if tween: tween.kill()
	tween = create_tween()

	content.text = text
	content.visible_characters = 0

	var index:= 0
	var last_punctuation_index:= 0
	var text_length := content.text.length()

	for letter in content.text:
		index+=1

		# only add a PropertyTweener at punctuations or end of string
		if not(letter in [".", "?", "!", ","] or index == text_length):
			continue

		# reveal letters between the last punctuation and the current one
		var duration = (index-last_punctuation_index) * LETTER_TIME
		tween.tween_property(content, "visible_characters", index, duration)

		# wait a bit after commas and punctuation
		if letter == ",": tween.tween_interval(PUNCTUATION_TIME/2.0)
		else: tween.tween_interval(PUNCTUATION_TIME)

		last_punctuation_index = index

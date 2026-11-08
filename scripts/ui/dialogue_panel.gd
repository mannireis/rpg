extends CanvasLayer

const LETTER_TIME = 0.04
const PUNCTUATION_TIME = 0.3
const BubbleButton = preload("res://scenes/ui/bubble_button.tscn")

var tween: Tween
var dialogue_index := 0

var _parsed_dialogue := {}
var _current_id := ""
var _current_line := 0

@onready var dialogue_panel: CanvasLayer = %DialoguePanel
@onready var speaker_label: Label = %SpeakerLabel
@onready var dialogue_label: RichTextLabel = %DialogueLabel
@onready var choices_container: VBoxContainer = %ChoicesContainer
@onready var line_edit: LineEdit = %LineEdit


func _ready():
	Signals.dialogue_started.connect(_on_dialogue_started)


func _on_dialogue_started(dialogue: String, at: StringName) -> void:
	GameState.dialoguing = true
	_parsed_dialogue = _parse(dialogue)
	show()
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
			var block_id := line.trim_prefix("===").strip_edges()

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
			elif line.begins_with("*") and line.contains("{") and line.contains("}"):
				var part := line.split(",", true, 3)

				var correct_answer := part[0].replace("{", "").replace("*", "").strip_edges()
				var correct := part[1].strip_edges()
				var wrong := part[2].replace("}", "").strip_edges()

				print(correct_answer + correct + wrong)

				current[-1]["text_box"].append({
					"correct_answer": correct_answer,
					"correct": correct,
					"wrong": wrong
				})

			elif line.contains(":"):
				var parts := line.split(":", true, 1)
				current.append({
					"speaker": parts[0].strip_edges(),
					"text": parts[1].strip_edges(),
					"choices": [],
					"text_box": [],
				})

	return parsed_dialogue


func _goto(id: StringName) -> void:
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


func _fill_vars(text: String) -> String:
	return text.replace("$player", GameState.player_name)


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
	GameState.dialoguing = false

	hide()

func _on_line(line: Dictionary) -> void:
	dialogue_label.hide()
	choices_container.hide()
	line_edit.hide()
	
	for child in choices_container.get_children():
		child.queue_free()

	speaker_label.text = _fill_vars(line["speaker"])

	# If text
	if (line["text"]):
		dialogue_label.show()

	say(_fill_vars(line["text"]))

	# If multiple-choice
	for choice in line["choices"]:
		choices_container.show()
		var b: Button = BubbleButton.instantiate()
		b.mouse_filter = Control.MOUSE_FILTER_STOP
		b.text = choice["text"]
		b.pressed.connect(choose.bind(choice["next"]))
		b.size_flags_horizontal = Control.SIZE_SHRINK_END
		choices_container.add_child(b)

	# If freeform
	for t in line["text_box"]:
		line_edit.show()
		var previous_conn = line_edit.text_submitted.get_connections().get(0)

		if (previous_conn):
			line_edit.text_submitted.disconnect(previous_conn.callable)

		line_edit.text_submitted.connect(_on_answer_submitted.bind(t))
		line_edit.grab_focus.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if not (event.is_action_pressed("Interact") or event.is_action_pressed("next")):
		return

	if tween and tween.is_running():
		tween.kill()
		dialogue_label.visible_characters = -1
	elif dialogue_panel.visible:
		if event.is_action_pressed("Interact") and len(choices_container.get_children()) > 1: print("trying to skip choices")
		else: advance()
		get_viewport().set_input_as_handled()


func say(text: String):
	if tween: tween.kill()
	tween = create_tween()
	
	dialogue_label.text = text
	dialogue_label.visible_characters = 0

	var index := 0
	var last_punctuation_index := 0
	var text_length := dialogue_label.text.length()

	for letter in dialogue_label.text:
		index += 1

		# only add a PropertyTweener at punctuations or end of string
		if letter not in [".", "?", "!", ","] and index != text_length:
			continue

		# reveal letters between the last punctuation and the current one
		var duration = (index - last_punctuation_index) * LETTER_TIME
		tween.tween_property(dialogue_label, "visible_characters", index, duration)

		# wait a bit after commas and punctuation
		if letter == ",":
			tween.tween_interval(PUNCTUATION_TIME / 2.0)
		else:
			tween.tween_interval(PUNCTUATION_TIME)

		last_punctuation_index = index


func _on_answer_submitted(text: String, data: Dictionary) -> void:
	var answer := text.strip_edges().to_lower()

	if answer == data["correct_answer"]:
		choose(data["correct"])
	else:
		choose(data["wrong"])

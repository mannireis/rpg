extends Node

signal new_line(line: Dictionary)
signal dialogue_ended

var active: bool = false
var _parsed_dialogue: Dictionary = {}
var _current_id := ""
var _current_line := 0


func start(file: String, start_id := "start") -> void:
	if not FileAccess.file_exists(file):
		push_error("Dialogue file missing in export (check export_presets include_filter): %s" % file)
		active = false
		_end()
		return
	var txt := FileAccess.get_file_as_string(file)
	if txt.is_empty():
		push_error("Dialogue file empty or failed to load: %s" % file)
		active = false
		_end()
		return
	_parsed_dialogue = _parse(txt)
	active = true
	_goto(start_id)


func _parse(source: String) -> Dictionary:
	var parsed_dialogue := {}
	var lines := source.split("\n")
	var current: Array = []
	var current_id := ""
	
	for line in lines:
		line = line.strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue

		if current_id == "" and line.ends_with("("):
			current_id = line.trim_suffix("(").strip_edges().to_lower()
			current = []
		elif line.ends_with(")"):
			parsed_dialogue[current_id] = current
			current_id = ""
		elif current_id != "":
			if line.contains(":"):
				var parts = line.split(":", true, 1)
				current.append({
					"speaker": parts[0].strip_edges(),
					"text": parts[1].strip_edges(),
					"choices": [],
				})
				
			elif line.contains(">"):
				var parts = line.split(">", true, 1)
				current[-1]["choices"].append({
					"text": parts[0].strip_edges(),
					"next": parts[1].strip_edges().to_lower(),
				})
		
	return parsed_dialogue


func _goto(id: String) -> void:
	if id == "end" or not _parsed_dialogue.has(id):
		_end()
		return
	_current_id = id
	_current_line = 0
	_show_line()


func _show_line() -> void:
	new_line.emit(_parsed_dialogue[_current_id][_current_line])


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
	active = false
	dialogue_ended.emit()

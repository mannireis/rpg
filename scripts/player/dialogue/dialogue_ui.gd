extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var speaker: Label = $Panel/MarginContainer/Speaker
@onready var content: Label = $Panel/MarginContainer/Content
@onready var choices: VBoxContainer = $Panel/MarginContainer/Choices

const LETTER_TIME:float = 0.04
const PUNCTUATION_TIME:float = 0.3

var tween: Tween
var dialogue_index: int = 0


func _ready() -> void:
	panel.hide()
	DialogueManager.new_line.connect(_on_line)
	DialogueManager.dialogue_ended.connect(panel.hide)


func _on_line(line: Dictionary) -> void:
	panel.show()
	speaker.text = line["speaker"]
	say(line["text"])
	
	for c in choices.get_children():
		c.queue_free()
	
	for c in line["choices"]:
		var b := Button.new()
		b.mouse_filter = Control.MOUSE_FILTER_STOP
		
		b.text = c["text"]
		b.pressed.connect(DialogueManager.choose.bind(c["next"]))
		choices.add_child(b)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("Interact"):
		return

	if tween and tween.is_running():
		tween.kill()
		content.visible_characters = -1
	elif content.visible and choices.get_child_count() == 0:
		DialogueManager.advance()
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

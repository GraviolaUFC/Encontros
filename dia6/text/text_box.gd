extends MarginContainer


@export
var dialogue_list: Array[String] = []
var current_dialog = -1
var current_text: String = ""
var current_character: int = 0


func _ready() -> void:
	next_dialogue()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		next_dialogue()
	%RichTextLabel.text = current_text.substr(0, current_character)


func next_dialogue() -> void:
	current_dialog += 1 
	if dialogue_list.get(current_dialog) != null:
		current_text = dialogue_list[current_dialog]
		current_character = 0


func _on_text_timer_timeout() -> void:
	current_character += 1
	current_character = min(current_text.length(), current_character)

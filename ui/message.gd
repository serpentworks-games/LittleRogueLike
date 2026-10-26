class_name Message
extends Label

const BASE_LABEL_SETTINGS = preload("res://assets/message_label_settings.tres")

var plain_text: String
var count: int = 1:
	set(value):
		count = value
		text = full_text()
		
func _init(msg_text: String, foreground_color: Color) -> void:
	plain_text = msg_text
	label_settings = BASE_LABEL_SETTINGS.duplicate()
	label_settings.font_color = foreground_color
	text = plain_text
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
func full_text() -> String:
	if count > 1:
		return "%s (x%d)" % [plain_text, count]
	return plain_text

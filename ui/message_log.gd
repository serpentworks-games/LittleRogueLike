class_name MessageLog
extends ScrollContainer

var last_msg: Message = null

@onready var message_list: VBoxContainer = %MessageList

static func send_message(text: String, color: Color) -> void:
	SignalBus.message_sent.emit(text, color)

func _ready() -> void:
	SignalBus.message_sent.connect(add_message)

func add_message(text: String, color: Color) -> void:
	if (last_msg != null and last_msg.plain_text == text):
		last_msg.count += 1
	else:
		var msg := Message.new(text, color)
		last_msg = msg
		message_list.add_child(msg)
		await get_tree().process_frame
		ensure_control_visible(msg)

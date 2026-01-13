class_name NamingPanel
extends SmoothPanel

signal name_submitted(new_name: String)

@onready var animated_line_edit: AnimatedLineEdit = %"Animated Line Edit"
@onready var accept_button: Button = %"Accept Button"

func _ready() -> void:
	animated_line_edit.text_submitted.connect(_on_name_submit)
	animated_line_edit.text_changed.connect(_on_text_changed)
	accept_button.pressed.connect(_on_accept_pressed)

func _on_name_submit(new_text: String) -> void:
	if not new_text.is_empty():
		name_submitted.emit(new_text)

func _on_text_changed(new_text: String) -> void:
	accept_button.disabled = new_text.is_empty()

func _on_accept_pressed() -> void:
	name_submitted.emit(animated_line_edit.text)

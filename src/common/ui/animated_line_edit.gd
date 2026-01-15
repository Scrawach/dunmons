class_name AnimatedLineEdit
extends PanelContainer

signal text_submitted(new_text: String)
signal text_changed(new_text: String)

@export var max_length: int = 16

@onready var line_edit: LineEdit = %LineEdit
@onready var container: HBoxContainer = $Container
@onready var custom_caret: Control = %"Custom Caret"

var cached_labels: Array[AnimatedLabel]

var text: 
	set(value):
		text = value
		line_edit.text = text
	get():
		return line_edit.text

func _ready() -> void:
	_fill_label_cache()
	line_edit.text_changed.connect(_on_text_changed)
	line_edit.text_submitted.connect(func(new_text): text_submitted.emit(new_text))
	line_edit.max_length = max_length

func _fill_label_cache() -> void:
	for i in max_length:
		var label := AnimatedLabel.new()
		container.add_child(label)
		cached_labels.append(label)

func _on_text_changed(new_text: String) -> void:
	text_changed.emit(new_text)
	custom_caret.position.x = 0
	for index in max_length:
		var label := cached_labels[index]
		
		if index < new_text.length():
			var letter = new_text[index]
			
			if label.text != letter:
				label.text = letter
				label.play_showing()
		else:
			label.play_hiding()
		
		if not label.hiding:
			_update_custom_caret(label)

func _update_custom_caret(label: AnimatedLabel) -> void:
	var font := label.get_theme_font(&"font")
	var font_size := label.get_theme_font_size(&"font_size")
	var text_size := font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	custom_caret.position.x = label.position.x + text_size.x

extends LineEdit

var animated_text: String

func _ready() -> void:
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String) -> void:
	print(new_text)
	pass

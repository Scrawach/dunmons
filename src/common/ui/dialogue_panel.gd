class_name DialoguePanel
extends SmoothPanel

@export var appear_duration: float = 0.4

@onready var label: Label = %Label

var tween: Tween

func show_message(content: String) -> void:
	label.text = content
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, 1.0).from(0)

func stop_writing() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

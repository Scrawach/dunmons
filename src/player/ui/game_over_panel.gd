class_name GameOverPanel
extends SmoothPanel

@onready var restart_button: Button = %"Restart Button"

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)

func smooth_show(duration: float = 0.5) -> void:
	_stop_tween_if_needed(appear_tween)
	show()
	appear_tween = create_tween()
	appear_tween.tween_property(self, "modulate:a", 1.0, duration).from(0.0)

func smooth_hide(duration: float = 0.4) -> void:
	_stop_tween_if_needed(appear_tween)
	appear_tween = create_tween()
	appear_tween.tween_property(self, "modulate:a", 0.0, duration)
	appear_tween.tween_callback(hide)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

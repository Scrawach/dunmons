class_name LocationTipPanel
extends SmoothPanel

@onready var title_label: Label = %"Title Label"
@onready var description_label: Label = %"Description Label"
@onready var start_button: Button = %"Start Button"

func setup(title: String, description: String) -> void:
	title_label.text = title
	description_label.text = description

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

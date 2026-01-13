class_name SmoothPanel
extends PanelContainer

var appear_tween: Tween

func smooth_show(duration: float = 0.4) -> void:
	_stop_tween_if_needed(appear_tween)
	show()
	pivot_offset = size / 2.0
	appear_tween = create_tween()
	appear_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	appear_tween.tween_property(self, "scale", Vector2(1, 1), duration).from(Vector2(0, 0))

func smooth_hide(duration: float = 0.4) -> void:
	_stop_tween_if_needed(appear_tween)
	pivot_offset = size / 2.0
	appear_tween = create_tween()
	appear_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	appear_tween.tween_property(self, "scale", Vector2(0, 0), duration)
	appear_tween.tween_callback(hide)

func _stop_tween_if_needed(target: Tween) -> void:
	if target:
		target.custom_step(9999)
		target.kill()

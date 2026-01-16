class_name TargetCircle
extends Node3D

var tween: Tween

func show_under(target: Node3D) -> void:
	
	_stop_if_needed()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	
	if not is_visible_in_tree():
		show()
		global_position = target.global_position
		tween.tween_property(self, "scale", Vector3.ONE, 0.4).from(Vector3.ZERO)
	else:
		tween.tween_property(self, "global_position", target.global_position, 0.4)

func smooth_hide() -> void:
	_stop_if_needed()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(hide)

func _stop_if_needed() -> void:
	if tween:
		tween.kill()

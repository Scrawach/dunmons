class_name AnimatedLabel
extends Label

const DURATION := 0.25

var tween: Tween
var height: float
var hiding: bool = true

func play_showing() -> void:
	hiding = false
	
	_kill_tween_if_needed()
	show()
	
	pivot_offset = size / 2.0
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	var base_position := position.y
	height = base_position
	tween.tween_property(self, "position:y", base_position, DURATION).from(base_position - 20)
	tween.parallel().tween_property(self, "scale:y", 1.0, DURATION).from(2.0)
	tween.parallel().tween_property(self, "rotation", 0, DURATION / 2).from(-0.3)
	tween.parallel().tween_property(self, "modulate:a", 1.0, DURATION / 4)
	

func play_hiding() -> void:
	hiding = true
	
	if text == "" or not is_visible_in_tree():
		return
	
	_kill_tween_if_needed()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	
	#tween.tween_property(self, "position:y", position.y - 20, DURATION)
	tween.parallel().tween_property(self, "scale:y", 2.0, DURATION / 4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, DURATION).from(1.0)
	tween.tween_callback(_on_hide)

func _on_hide() -> void:
	hide()
	text = ""

func _kill_tween_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

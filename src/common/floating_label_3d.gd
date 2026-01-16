class_name FloatingLabel3D
extends Label3D

func launch(new_text: String) -> void:
	text = new_text
	var random_direction := get_random_direction() / 2
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "position", position + random_direction, 0.4)
	tween.parallel().tween_property(self, "scale", Vector3.ONE, 0.3).from(Vector3.ZERO)
	#tween.tween_property(self, "position", position + random_direction / 1.5, 1.5)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.3)
	tween.tween_callback(self.queue_free)

func get_random_direction() -> Vector3:
	var x := randf_range(-1, 1)
	var z := randf_range(-1, 1)
	return Vector3(x, 3, z)

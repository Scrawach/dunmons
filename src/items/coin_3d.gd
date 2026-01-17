class_name Coin3D
extends Node3D

@onready var model_root: Node3D = %"Model Root"

func launch(value: int) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(model_root, "scale", Vector3.ONE, 0.7).from(Vector3.ZERO)
	tween.parallel().tween_property(model_root, "position:y", 3.5, 1.25).from(0)
	tween.parallel().tween_property(model_root, "rotation:y", deg_to_rad(360), 0.9).from(0)
	tween.tween_property(model_root, "scale", Vector3.ONE * 1.4, 0.15)
	tween.tween_property(model_root, "scale", Vector3.ZERO, 0.35)
	tween.tween_callback(queue_free) 

class_name Coin3D
extends Node3D

@onready var model_root: Node3D = %"Model Root"

func launch(value: int) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_interval(0.3)
	tween.tween_property(model_root, "scale",  Vector3.ONE, 0.6).from(Vector3.ZERO)
	tween.parallel().tween_property(model_root, "position:y", 3.5, 0.4).from(0)
	#tween.parallel().tween_property(model_root, "rotation:y", deg_to_rad(360), 1.2).from(0)
	tween.tween_interval(0.5)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(model_root, "scale", Vector3.ZERO, 0.35)
	tween.tween_callback(queue_free) 

func _physics_process(delta: float) -> void:
	rotate_y(180 * delta)

extends Node3D

const HIT_LABEL_3D = preload("uid://b2gw3gp2wjl8j")

@export var location: LocationPart
@export var dummy: Monster

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_Q:
			location.smooth_show()
		elif event.keycode == KEY_E:
			location.smooth_hide()
		elif event.keycode == KEY_S:
			spawn_hit(dummy, randi_range(1, 12))

func spawn_hit(target: Monster, value: int) -> void:
	var hit := HIT_LABEL_3D.instantiate() as HitLabel3D
	add_child(hit)
	hit.global_position = target.global_position
	hit.launch(str(value))

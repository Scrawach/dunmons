extends Node3D

const HIT_LABEL_3D = preload("uid://b2gw3gp2wjl8j")

@export var location: LocationPart
@export var dummy: Monster

func _physics_process(delta: float) -> void:
	for child in get_children():
		if child is Monster:
			child.restore_stamine(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_Q:
			location.smooth_show()
		elif event.keycode == KEY_E:
			location.smooth_hide()
		elif event.keycode == KEY_S:
			dummy.take_damage(randi_range(1, 3))
		elif event.keycode == KEY_1:
			dummy.attack_async(dummy)
		elif event.keycode == KEY_2:
			dummy.die()
		elif event.keycode == KEY_3:
			dummy.revive()

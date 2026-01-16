extends Node3D

const HIT_LABEL_3D = preload("uid://b2gw3gp2wjl8j")

@export var location: LocationPart
@export var dummy: Monster
@export var marker1: Marker3D
@export var marker2: Marker3D


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
			dummy.restore_health(randi_range(1, 3))
		elif event.keycode == KEY_Z:
			dummy.is_walking = not dummy.is_walking
		elif event.keycode == KEY_A:
			dummy.monster_world_ui.smooth_hide()
			dummy.move_to(marker1.global_position)
		elif event.keycode == KEY_D:
			dummy.move_to(marker2.global_position)
			dummy.monster_world_ui.smooth_show()

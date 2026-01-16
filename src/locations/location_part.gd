class_name LocationPart
extends Node3D

@export var disable_rotation: bool

var base_rotation: Array[Vector3]
var base_position: Array[Vector3]
var base_scale: Array[Vector3]

var tweens: Array[Tween]

func initialize() -> void:
	for child in get_children():
		base_rotation.append(child.rotation)
		base_position.append(child.position)
		base_scale.append(child.scale)

func smooth_show() -> void:
	stop_if_needed()
	var index: int = 0
	for item in get_children():
		var tween := item.create_tween()
		tweens.append(tween)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
		tween.tween_interval(0.01 * index)
		tween.tween_property(item, "scale", base_scale[index], randf_range(0.3, 0.6))
		tween.parallel().tween_property(item, "position", base_position[index], 0.5).from(base_position[index]-Vector3(0, 0.2, 0))
		
		if not disable_rotation:
			tween.parallel().tween_property(item, "rotation", base_rotation[index], 0.5).from(base_rotation[index] + Vector3(deg_to_rad(180), 0, 0))
		index += 1
		

func smooth_hide() -> void:
	stop_if_needed()
	var childrens := get_children()
	childrens.reverse()
	var index: int = childrens.size() - 1
	var target_scale := Vector3.ONE * 0.01
	for item in childrens:
		var tween := item.create_tween()
		tweens.append(tween)
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_interval(0.01 * (childrens.size() - index))
		tween.tween_property(item, "scale", target_scale, 0.6)
		
		if not disable_rotation:
			tween.parallel().tween_property(item, "rotation", base_rotation[index] - Vector3(deg_to_rad(180), 0, 0), 0.5)
		index -= 1

func stop_if_needed() -> void:
	if tweens.is_empty():
		return
	
	for tween in tweens:
		tween.custom_step(9999)
		tween.kill()
	tweens.clear()

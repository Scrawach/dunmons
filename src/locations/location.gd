class_name Location
extends Node3D

@export var length: float
@export var camera_point: Node3D
@export var spawn_point: Node3D

@export var player_positions: Node3D
@export var enemy_positions: Node3D

var parts: Array[LocationPart]

func initialize() -> void:
	for child in get_children():
		if child is LocationPart:
			child.initialize()
			child.smooth_hide()
			child.stop_if_needed()
			parts.append(child)

func get_travel_points() -> Array[Vector3]:
	return get_points(player_positions)

func get_enemy_points() -> Array[Vector3]:
	return get_points(enemy_positions)

func get_points(target: Node3D) -> Array[Vector3]:
	var points: Array[Vector3]
	for point in target.get_children():
		points.append(point.global_position)
	return points

func smooth_show() -> void:
	for part in parts:
		part.smooth_show()

func smooth_hide() -> void:
	for part in parts:
		part.smooth_hide()

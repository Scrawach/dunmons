class_name Sands
extends Node3D

@export var sands: Array[Node3D]
@export var threshold: float = 100.0

var previous_reached_distance := 0.0
var moving_index: int = 0

func move_if_needed(reached_distance: float) -> void:
	var offset := reached_distance - previous_reached_distance
	
	if offset >= threshold:
		move_sands(threshold)
		previous_reached_distance += threshold

func move_sands(distance: float) -> void:
	var sand := sands[moving_index]
	moving_index += 1
	moving_index %= sands.size()
	sand.global_position.z -= (distance * sands.size())

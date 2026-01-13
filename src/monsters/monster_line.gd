class_name MonsterLine
extends Node3D

@export var capacity: int = 3

@export var monsters: Array[Monster]

@onready var points: Node3D = %Points

func _ready() -> void:
	for monster in monsters:
		append(monster)

func get_first() -> Monster:
	return monsters.front()

func append(monster: Monster) -> void:
	monster.dragged.connect(_on_dragged)
	monster.end_dragged.connect(_on_end_dragged)
	pass

func has_creatures() -> bool:
	for monster in monsters:
		if not monster.is_alive:
			return false
	return true

func _on_dragged(monster: Monster) -> void:
	## TODO: Change monster positions
	pass

func _on_end_dragged(monster: Monster) -> void:
	var nearest_position := get_nearest_position(monster.global_position)
	monster.global_position = nearest_position
	## TODO: Setup monster on new position with smooth translate
	pass

func get_nearest_position(target_position: Vector3) -> Vector3:
	var previous_distance := 1_000.0
	var target := Vector3(0, 0, 0)
	for point in points.get_children():
		var distance := target_position.distance_squared_to(point.global_position)
		
		if distance < previous_distance:
			previous_distance = distance
			target = point.global_position
		
	return target

class_name MonsterLine
extends RefCounted

var monsters: Array[Monster]
var points: Array[Vector3]

func _init(init_monsters: Array[Monster]) -> void:
	monsters = init_monsters

func get_first() -> Monster:
	for monster in monsters:
		if not monster.is_death:
			return monster
	return null

func is_moving() -> bool:
	for monster in monsters:
		if monster.is_walking:
			return true
	return false

func setup_points(p: Array[Vector3]) -> void:
	points = p

func find_monsters_with_tags(targets: Array[Tags.Type]) -> Array[Monster]:
	var result: Array[Monster]
	for monster in monsters:
		if not monster.is_death and monster.has_tags(targets):
			result.append(monster)
	return result

func switch_positions(a: Monster, b: Monster, duration: float = 0.25) -> void:
	if a == b:
		return
	
	var a_index := monsters.find(a)
	var b_index := monsters.find(b)
	
	var temp := monsters[a_index].global_position
	monsters[a_index].drag_to(monsters[b_index].global_position, duration)
	monsters[b_index].drag_to(temp, duration)

func sort_by_positions(exclude: Node3D = null) -> void:
	monsters.sort_custom(sort_by_position_func)
	for i in monsters.size():
		var desired_position := points[i]
		var monster := monsters[i]
		
		if monster != exclude:
			monster.drag_to(desired_position, 0.1)

func sort_by_position_func(a: Monster, b: Monster):
	if a.global_position.z < b.global_position.z:
		return true
	return false

func erase_from_death() -> Array[Monster]:
	var dead: Array[Monster]
	for monster in monsters:
		if monster.is_death:
			dead.append(monster)
	
	for monster in dead:
		monsters.erase(monster)
	return dead

func has_creatures() -> bool:
	return monsters.any(func(monster: Monster): return not monster.is_death)

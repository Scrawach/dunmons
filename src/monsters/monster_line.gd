class_name MonsterLine
extends RefCounted

var monsters: Array[Monster]

func _init(init_monsters: Array[Monster]) -> void:
	monsters = init_monsters

func get_first() -> Monster:
	for monster in monsters:
		if not monster.is_death:
			return monster
	return null

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

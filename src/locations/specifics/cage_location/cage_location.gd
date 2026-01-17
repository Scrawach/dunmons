class_name CageLocation
extends Location

signal selected(monster: Monster, escape_point: Vector3)

@export var cages: Array[Cage]

@onready var last_escape_position: Marker3D = %"Last Escape Position"

var caged_monsters: Array[Monster]
var mapping: Dictionary[Monster, Cage]
var target: Monster

func attach_monsters(monsters: Array[Monster]) -> void:
	caged_monsters = monsters
	for i in cages.size():
		var monster := caged_monsters[i]
		var cage := cages[i]
		
		monster.global_position = cage.monster_position.global_position
		monster.look_at(cage.escape_position.global_position, Vector3.UP, true)
		cage.open()
		mapping[monster] = cage
		monster.emotion.play(Emotion.Type.SAD)
	
	Events.monster_hover.connect(_on_monster_hovered)
	Events.monster_unhover.connect(_on_monster_unhovered)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_drag") and target:
		selected.emit(target, mapping[target].escape_position.global_position)

func deattch_monsters() -> void:
	caged_monsters.clear()
	
	Events.monster_hover.disconnect(_on_monster_hovered)
	Events.monster_unhover.disconnect(_on_monster_unhovered)

func _on_monster_hovered(monster: Monster) -> void:
	target = monster
	for key in mapping:
		key.play_fear()
		if key != monster:
			mapping[key].close()
	monster.play_unfear()


func _on_monster_unhovered(monster: Monster) -> void:
	target = null
	for key in mapping:
		key.play_unfear()
	for cage in cages:
		cage.open()
	

class_name Startup
extends Scenario

@export var hud: PlayerHUD
@export var camera_point: CameraPoint
@export var cage_location: CageLocation
@export var world: Node3D
@export var startup_monsters: Array[PackedScene]
@export var tag_data: Tags

func initialize() -> void:
	var monsters := spawn_startup_monsters()
	camera_point.zoom_to_point(cage_location.camera_point.global_position, 15, 160)
	hud.show_location_tip("choose wisely", "you can save only one")
	cage_location.attach_monsters(monsters)

func get_monster() -> Monster:
	var data = await cage_location.selected
	hud.hide_location_tip()
	
	cage_location.deattch_monsters()
	
	var selected := data[0] as Monster
	var target_point := data[1] as Vector3
	selected.move_to(target_point)
	camera_point.zoom_out()
	await wait_async(1.0)
	return selected

func spawn_startup_monsters(count: int = 3) -> Array[Monster]:
	var result: Array[Monster]
	for i in count:
		var random = startup_monsters.pick_random()
		var monster := random.instantiate() as Monster
		world.add_child(monster)
		result.append(monster)
		
		var element_tags := tag_data.get_elemental_tags()
		var random_element := element_tags.pick_random() as Tags.Type
		monster.remove_tags(element_tags)
		monster.add_tag(random_element)
		monster.repaint(tag_data.get_material_for(random_element))
	return result

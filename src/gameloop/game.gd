class_name Game
extends Scenario

@export var player_monsters: Array[Monster]
@export var camera_point: CameraPoint
@export var enemies: Array[PackedScene]

@export var world: Node3D
@export var sands: Sands
@export var start_location: Location
@export var location_scenes: Array[PackedScene]

@export var target: Monster

var previous_location: Location
var reached_distance: float

func _ready() -> void:
	execute_async()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey:
		if event.keycode == KEY_Q:
			camera_point.zoom_to(target)
		elif event.keycode == KEY_W:
			camera_point.zoom_out()

func execute_async() -> void:
	return
	start_location.initialize()
	await move_to(start_location)
	while true:
		var location := make_new_location(reached_distance)
		spawn_enemies(location)
		location.initialize()
		await move_to(location)
		sands.move_if_needed(reached_distance)

func make_new_location(offset: float) -> Location:
	var random := location_scenes.pick_random() as PackedScene
	var instance := random.instantiate() as Location
	world.add_child(instance)
	instance.position.z = -offset
	return instance

func move_to(target: Location) -> void:
	var travel_points := target.get_travel_points()
	for i in player_monsters.size():
		player_monsters[i].move_to(travel_points[i])
	camera_point.move_to(target.camera_point.global_position, 4.0)
	
	await wait_async(1.0)
	if previous_location:
		previous_location.smooth_hide()
	await wait_async(1.0)
	
	target.smooth_show()
	
	while player_monsters.front().is_walking:
		await wait_async(0.5)
	
	reached_distance += target.length
	if previous_location:
		previous_location.queue_free()
	previous_location = target

func spawn_enemies(location: Location) -> void:
	var enemy_count := randi_range(1, 3)
	var points := location.get_enemy_points()
	for i in enemy_count:
		var random := enemies.pick_random() as PackedScene
		var instance := random.instantiate() as Monster
		location.spawn_point.add_child(instance)
		instance.global_position = points[i]

class_name Game
extends Scenario

@export var player_monsters: Array[Monster]
@export var camera_point: CameraPoint
@export var enemies: Array[PackedScene]

@export var world: Node3D
@export var sands: Sands
@export var start_location: Location
@export var location_scenes: Array[PackedScene]

@export var tactics: Tactics
@export var battle: Battle

var previous_location: Location
var reached_distance: float

func _ready() -> void:
	execute_async()

func execute_async() -> void:
	start_location.initialize()
	var player := MonsterLine.new(player_monsters)
	await move_to(player, start_location)
	while true:
		var location := make_new_location(reached_distance)
		var enemy_line := spawn_enemies(location)
		location.initialize()
		await move_to(player, location)
		sands.move_if_needed(reached_distance)
		await tactics.prepare_async(player, location)
		var battle_result := await battle.simulate_async(player, enemy_line)
		player.erase_from_death()
		if battle_result.is_enemy_won:
			await game_over_async()
			return

func game_over_async() -> void:
	print("GAME OVER")

func make_new_location(offset: float) -> Location:
	var random := location_scenes.pick_random() as PackedScene
	var instance := random.instantiate() as Location
	world.add_child(instance)
	instance.position.z = -offset
	return instance

func move_to(line: MonsterLine, target: Location) -> void:
	var travel_points := target.get_travel_points()
	for i in line.monsters.size():
		line.monsters[i].move_to(travel_points[i])
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

func spawn_enemies(location: Location) -> MonsterLine:
	var enemy_count := randi_range(1, 3)
	var points := location.get_enemy_points()
	var enemy_monsters: Array[Monster]
	for i in enemy_count:
		var random := enemies.pick_random() as PackedScene
		var instance := random.instantiate() as Monster
		location.spawn_point.add_child(instance)
		instance.global_position = points[i]
		enemy_monsters.append(instance)
	return MonsterLine.new(enemy_monsters)

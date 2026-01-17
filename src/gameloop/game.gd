class_name Game
extends Scenario

@export var camera_point: CameraPoint
@export var enemies: Array[PackedScene]

@export var world: Node3D
@export var sands: Sands
@export var start_location: Location
@export var location_scenes: Array[PackedScene]

@export var loading_curtain: LoadingCurtain

@export var startup: Startup
@export var tactics: Tactics
@export var battle: Battle
@export var game_over: GameOver


var previous_location: Location
var reached_distance: float
var location_number: int

var player_line: MonsterLine

func _ready() -> void:
	startup.initialize()
	loading_curtain.smooth_hide(execute_async)

func execute_async() -> void:
	var startup_monster := await startup.get_monster()
	player_line = MonsterLine.new([startup_monster])
	reached_distance = startup.cage_location.length
	while true:
		var location := make_new_location(reached_distance)
		var enemy_line := spawn_enemies(location)
		location.initialize()
		await move_to(player_line, location)
		sands.move_if_needed(reached_distance)
		await tactics.prepare_async(player_line, location)
		var battle_result := await battle.simulate_async(player_line, enemy_line)
		player_line.erase_from_death()
		
		if battle_result.is_enemy_won:
			await game_over.execute()
			return

func make_new_location(offset: float) -> Location:
	location_number += 1
	var random := location_scenes[location_number % location_scenes.size()]
	var instance := random.instantiate() as Location
	world.add_child(instance)
	instance.position.z = -offset
	return instance

func move_to(line: MonsterLine, target: Location) -> void:
	var travel_points := target.get_travel_points()
	line.setup_points(travel_points)
	for i in line.monsters.size():
		line.monsters[i].move_to(travel_points[i])
	camera_point.move_to(target.camera_point.global_position, 4.0)
	
	await wait_async(1.0)
	if previous_location:
		previous_location.smooth_hide()
	await wait_async(1.0)
	
	target.smooth_show()
	
	while line.is_moving():
		await wait_async(0.5)
	
	for monster in line.monsters:
		monster.look_at(monster.global_position + Vector3.FORWARD, Vector3.UP, true)
	
	reached_distance += target.length
	if previous_location:
		previous_location.queue_free()
	previous_location = target

func spawn_enemies(location: Location) -> MonsterLine:
	var enemy_count := randi_range(1, 1)
	var points := location.get_enemy_points()
	var enemy_monsters: Array[Monster]
	for i in enemy_count:
		var random := enemies.pick_random() as PackedScene
		var instance := random.instantiate() as Monster
		location.spawn_point.add_child(instance)
		instance.global_position = points[i]
		enemy_monsters.append(instance)
	return MonsterLine.new(enemy_monsters)

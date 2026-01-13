class_name Game
extends Scenario

@export var battle: Battle
@export var world_3d: Node3D
@export var player_line: MonsterLine
@export var current_location: Location
@export var location_template: PackedScene

func _ready() -> void:
	execute_async()

func execute_async() -> void:
	while true:
		battle.setup(player_line, current_location.enemies)
		var result := await battle.execute_async()
		
		if not result.is_player_win:
			game_over()
			return
		
		current_location = await move_to_next_location_async()

func move_to_next_location_async() -> Location:
	var instance: Location = location_template.instantiate() as Location
	world_3d.add_child(instance)
	instance.position = current_location.position - Vector3(0, 0, instance.length)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(player_line, "global_position:z", instance.player_position.global_position.z, 2.0)
	await wait_async(2.0)
	return instance

func game_over() -> void:
	pass

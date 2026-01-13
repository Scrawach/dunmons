class_name Game
extends Scenario

@export var battle: Battle
@export var world_3d: Node3D
@export var player_line: MonsterLine
@export var current_location: Location
@export var location_template: PackedScene
@export var player_hud: PlayerHUD

func _ready() -> void:
	execute_async()

func execute_async() -> void:
	process_join_to_party_async()
	return
	while true:
		battle.setup(player_line, current_location.enemies)
		var result := await battle.execute_async()
		
		if not result.is_player_win:
			game_over()
			return
		
		await process_join_to_party_async()
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

func process_join_to_party_async() -> void:
	await wait_until(func(): return Input.is_anything_pressed())
	print("someone want join to party")
	player_hud.show_background()
	player_hud.show_dialogue("Someone want join to party!")
	await wait_async(0.1)
	await wait_until(func(): return Input.is_anything_pressed())
	player_hud.hide_dialogue()
	await wait_async(0.1)
	await wait_until(func(): return Input.is_anything_pressed())
	player_hud.show_naming()
	await wait_async(0.1)
	await wait_until(func(): return Input.is_anything_pressed())
	player_hud.hide_naming()
	player_hud.hide_background()

func game_over() -> void:
	print("game over")
	pass

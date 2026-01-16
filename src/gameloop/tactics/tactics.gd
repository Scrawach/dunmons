class_name Tactics
extends Scenario

const TITLE := "Preparation"
const DESCRIPTION := "before battle starts, you can change creature positions"

@export var player_hud: PlayerHUD

func prepare_async(line: MonsterLine, location: Location) -> void:
	location.show_tactics_positions()
	show_monster_ui(line)
	await player_hud.show_location_description(TITLE, DESCRIPTION)
	location.hide_tactics_positions()
	hide_monster_ui(line)
	await wait_async(1.0)

func show_monster_ui(line: MonsterLine) -> void:
	for monster in line.monsters:
		monster.monster_world_ui.unblock()

func hide_monster_ui(line: MonsterLine) -> void:
	for monster in line.monsters:
		monster.monster_world_ui.block()

class_name Tactics
extends Scenario

const TITLE := "Preparation"
const DESCRIPTION := "before battle starts, you can change formation"

@export var player_hud: PlayerHUD
@export var drag_and_drop: DragAndDrop3D

var player_line: MonsterLine

func prepare_async(line: MonsterLine, location: Location) -> void:
	if line.monsters.size() <= 1:
		return
	
	player_line = line
	location.show_tactics_positions()
	show_monster_ui(line)
	
	drag_and_drop.include(line.monsters)
	drag_and_drop.enable()
	drag_and_drop.dragged.connect(_on_dragged)
	drag_and_drop.end_dragged.connect(_on_end_dragged)
		
	await player_hud.show_location_description(TITLE, DESCRIPTION)
	
	drag_and_drop.disable()
	drag_and_drop.dragged.disconnect(_on_dragged)
	drag_and_drop.end_dragged.disconnect(_on_end_dragged)
	
	location.hide_tactics_positions()
	hide_monster_ui(line)
	await wait_async(1.0)

func show_monster_ui(line: MonsterLine) -> void:
	for monster in line.monsters:
		monster.monster_world_ui.unblock()

func hide_monster_ui(line: MonsterLine) -> void:
	for monster in line.monsters:
		monster.monster_world_ui.block()

func _on_dragged(area: DraggingArea3D) -> void:
	player_line.sort_by_positions(area.body)

func _on_end_dragged(area: DraggingArea3D) -> void:
	player_line.sort_by_positions()

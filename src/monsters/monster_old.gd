class_name MonsterOld
extends Node3D

signal dragged(monster: MonsterOld)
signal end_dragged(monster: MonsterOld)

@export var monster_name: String
@export var health: int = 2
@export var damage: int = 1

@onready var dragging_area_3d: DraggingArea3D = %"Dragging Area3D"

var is_alive: bool = true

func _ready() -> void:
	dragging_area_3d.disable()
	dragging_area_3d.dragged.connect(func(_pos): dragged.emit(self))
	dragging_area_3d.end_dragged.connect(func(): end_dragged.emit(self))

func attack_async(target: Monster) -> void:
	print("%s attack %s" % [monster_name, target.monster_name])
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale:y", 1.0, 0.5).from(0.5)
	await get_tree().create_timer(1.0).timeout

func take_damage_async(damage: int) -> void:
	print("%s taken %s damage points" % [monster_name, damage])
	health -= damage
	
	if health <= 0:
		is_alive = false
		await play_death_async()

func play_death_async() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale:y", 0.1, 0.5).from(1.0)
	await get_tree().create_timer(0.5).timeout

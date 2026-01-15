class_name Monster
extends Node3D

signal stat_changed(monster: Monster)
signal died(monster: Monster)
signal hit()

@export var data: MonsterInfo
@export var hit_scene: PackedScene

@onready var base_animation_tree: AnimationTree = %BaseAnimationTree
@onready var monster_world_ui: MonsterWorldUI = %"Monster World UI"

var health: int
var damage: int
var stamina: float

var is_death: bool
var is_walking: bool

func _ready() -> void:
	health = data.health
	damage = data.attack
	monster_world_ui.update_health_progress_bar(float(health) / data.health)
	monster_world_ui.update_stamina_progress_bar(0)
	stat_changed.emit(self)

func restore_stamine(tick: float) -> void:
	stamina += tick * data.stamina
	if stamina >= 1.0:
		stamina = 1.0
	monster_world_ui.update_stamina_progress_bar(stamina)
	stat_changed.emit(self)

func die() -> void:
	is_death = true
	died.emit(self)

func revive() -> void:
	is_death = false

func take_damage(value: int) -> void:
	if is_death:
		return
	
	spawn_floating_damage_numbers(value)
	hit.emit()
	health = max(0, health - value)
	stat_changed.emit(self)
	if health <= 0:
		die()
	monster_world_ui.update_health_progress_bar(float(health) / data.health)

func restore_health(value: int) -> void:
	if is_death:
		is_death = false
	health = min(data.health, health + value)
	stat_changed.emit(self)
	monster_world_ui.update_health_progress_bar(float(health) / data.health)

func attack_async(_target: Monster) -> void:
	stamina = 0.0
	base_animation_tree.set("parameters/Attack/request", 1)
	await base_animation_tree.animation_finished

func spawn_floating_damage_numbers(value: int) -> void:
	var hit_instance := hit_scene.instantiate() as HitLabel3D
	get_parent().add_child(hit_instance)
	hit_instance.position = position
	hit_instance.launch(str(value))

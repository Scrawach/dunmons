class_name Monster
extends Node3D

const TAKE_DAMAGE_ANIMATION := "Take Damage"
const ATTACK_ANIMATION := "Attack"

signal died(monster: Monster)

@export var data: MonsterInfo
@export var movement_speed: float = 6.0
@export var hit_scene: PackedScene
@export var heal_scene: PackedScene

@onready var base_animation_tree: AnimationTree = %BaseAnimationTree
@onready var monster_world_ui: MonsterWorldUI = %"Monster World UI"

@onready var health: Health = %Health
@onready var stamina: Stamina = %Stamina

var damage_min: int
var damage_max: int

var is_death: bool
var is_walking: bool

var moving: Tween

func _ready() -> void:
	health.initialize(data.health)
	stamina.initialize(0.0)
	damage_min = data.attack_min
	damage_max = data.attack_max

func restore_stamine(tick: float) -> void:
	if stamina.is_full():
		return
	
	stamina.restore(tick * data.stamina)

func die() -> void:
	is_death = true
	died.emit(self)

func revive() -> void:
	is_death = false

func take_damage(value: int) -> void:
	if is_death:
		return
	health.take_damage(value)
	spawn_floating_numbers(hit_scene, value)
	play_oneshot_animation(TAKE_DAMAGE_ANIMATION)
	
	if health.is_empty():
		die()

func move_to(target_position: Vector3) -> void:
	if moving:
		moving.kill()
	
	is_walking = true
	var distance := target_position.distance_to(global_position)
	var movement_time := distance / movement_speed
	moving = create_tween()
	
	if distance > 0.1:
		look_at(target_position, Vector3.UP, true)
	
	moving.tween_property(self, "global_position", target_position, movement_time)
	moving.tween_callback(func(): is_walking = false)

func restore_health(value: int) -> void:
	if is_death:
		is_death = false
	health.heal(value)
	spawn_floating_numbers(heal_scene, value)

func attack_async(_target: Monster) -> void:
	stamina.consume()
	play_oneshot_animation(ATTACK_ANIMATION)
	await base_animation_tree.animation_finished

func spawn_floating_numbers(scene: PackedScene, value: int) -> void:
	var hit_instance := scene.instantiate() as FloatingLabel3D
	get_parent().add_child(hit_instance)
	hit_instance.position = position
	hit_instance.launch(str(value))

func play_oneshot_animation(animation_name: String) -> void:
	const FIRE_CODE := 1
	base_animation_tree.set("parameters/%s/request" % animation_name, FIRE_CODE)

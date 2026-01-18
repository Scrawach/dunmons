class_name Monster
extends Node3D

const TAKE_DAMAGE_ANIMATION := "Take Damage"
const ATTACK_ANIMATION := "Attack"
const ALT_ATTACK_ANIMATION := "Stomp"
const ALT_ATTACK_CHANCE := 0.2

signal died(monster: Monster)

@export var body: MeshInstance3D
@export var data: MonsterInfo
@export var movement_speed: float = 6.0
@export var hit_scene: PackedScene
@export var heal_scene: PackedScene
@export var tag_scene: PackedScene

@onready var base_animation_tree: AnimationTree = %BaseAnimationTree
@onready var monster_world_ui: MonsterWorldUI = %"Monster World UI"

@onready var health: Health = %Health
@onready var stamina: Stamina = %Stamina
@onready var emotion: Emotion = %Emotion


var damage_min: int
var damage_max: int
var speed: float
var tags: Array[Tags.Type]

var is_death: bool
var is_walking: bool
var is_fearing: bool

var moving: Tween

func _ready() -> void:
	health.initialize(data.health)
	stamina.initialize(0.0)
	damage_min = data.attack_min
	damage_max = data.attack_max
	speed = data.stamina
	tags = data.tags.duplicate()

func remove_tags(remove: Array[Tags.Type]) -> void:
	for item in remove:
		var index := tags.find(item)
		
		if index == -1:
			continue
		
		tags.remove_at(index)

func add_tag(tag: Tags.Type) -> void:
	tags.append(tag)

func repaint(target: Material) -> void:
	body.set_surface_override_material(0, target)

func can_attack() -> bool:
	return not is_death and stamina.is_full()

func restore_stamine(tick: float) -> void:
	if stamina.is_full():
		return
	
	stamina.restore(tick * speed)

func has_tags(targets: Array[Tags.Type]) -> bool:
	var result := true
	for target_tag in targets:
		result = result && (target_tag in tags)
	return result

func die() -> void:
	is_death = true
	emotion.play(Emotion.Type.DEAD)
	died.emit(self)

func revive() -> void:
	is_death = false
	emotion.play(Emotion.Type.SMILE)

func take_damage_async(value: int) -> void:
	take_damage(value)
	await base_animation_tree.animation_finished

func take_damage(value: int) -> void:
	if is_death:
		return
	health.take_damage(value)
	spawn_floating_numbers(hit_scene, value)
	play_oneshot_animation(TAKE_DAMAGE_ANIMATION)
	
	if health.is_empty():
		die()

func spawn_tag(tag: Tags.Type) -> void:
	var instance := tag_scene.instantiate() as TagWorldUI
	get_parent().add_child(instance)
	instance.global_position = global_position
	instance.initialize(tag)

func drag_to(target_position: Vector3, duration: float = 0.25) -> void:
	if moving:
		moving.kill()
		is_walking = false
	moving = create_tween()
	moving.tween_property(self, "global_position", target_position, duration)

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

func restore_health(value: int, is_can_revive: bool = true) -> void:
	if is_death and not is_can_revive:
		return
	
	if is_death:
		revive()
	
	health.heal(value)
	spawn_floating_numbers(heal_scene, value)

func attack_async(_target: Monster) -> void:
	var attack_animation = ATTACK_ANIMATION if randf() > ALT_ATTACK_CHANCE else ALT_ATTACK_ANIMATION
	play_oneshot_animation(attack_animation)
	await base_animation_tree.animation_finished
	stamina.consume()

func play_fear() -> void:
	is_fearing = true
	emotion.play(Emotion.Type.CRY)

func play_unfear() -> void:
	is_fearing = false
	emotion.play(Emotion.Type.SAD)

func spawn_floating_numbers(scene: PackedScene, value: int) -> void:
	var hit_instance := scene.instantiate() as FloatingLabel3D
	get_parent().add_child(hit_instance)
	hit_instance.position = position
	hit_instance.launch(str(value))

func play_oneshot_animation(animation_name: String) -> void:
	const FIRE_CODE := 1
	base_animation_tree.set("parameters/%s/request" % animation_name, FIRE_CODE)

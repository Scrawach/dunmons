class_name HitEffect
extends Node

@export var body: MeshInstance3D
@export var health: Health
@export var hit_material: Material
@export var heal_material: Material
@export var duration: float = 0.1

var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	health.hit.connect(_on_hit)
	health.healed.connect(_on_heal)

func _on_hit(_value: int) -> void:
	play_hit()

func _on_heal(_value: int) -> void:
	change_material_to(heal_material)

func play_hit() -> void:
	change_material_to(hit_material)

func change_material_to(target: Material) -> void:
	if body == null:
		return
	
	timer.start(duration)
	body.material_override = target

func _on_timeout() -> void:
	if body == null:
		return
	
	body.material_override = null

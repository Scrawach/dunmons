class_name HitEffect
extends Node

@export var body: MeshInstance3D
@export var monster: Monster
@export var material: Material
@export var duration: float = 0.1

var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	monster.hit.connect(_on_hit)

func _on_hit() -> void:
	play_hit()

func play_hit() -> void:
	if body == null:
		return
	
	timer.start(duration)
	body.material_override = material

func _on_timeout() -> void:
	if body == null:
		return
	
	body.material_override = null

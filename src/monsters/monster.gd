class_name Monster
extends Node3D

@export var data: MonsterInfo

@onready var base_animation_player: AnimationPlayer = %BaseAnimationPlayer
@onready var monster_world_ui: MonsterWorldUI = %"Monster World UI"

var stamina: float

func _physics_process(delta: float) -> void:
	stamina += delta
	monster_world_ui.update_stamina_progress_bar(stamina / data.speed)
	if stamina >= data.speed:
		stamina = 0

func take_damage() -> void:
	base_animation_player.play("death")

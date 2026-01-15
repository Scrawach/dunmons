class_name MonsterWorldUI
extends Sprite3D

@export var monster: Monster

@onready var health_bar: ProgressBar = %"Health Bar"
@onready var stamina_bar: ProgressBar = %"Stamina Bar"

func _ready() -> void:
	monster.died.connect(_on_died)

func _on_died(_monster: Monster) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.45)

func update_stamina_progress_bar(progress: float) -> void:
	stamina_bar.value = stamina_bar.max_value * progress

func update_health_progress_bar(progress: float) -> void:
	health_bar.value = health_bar.max_value * progress

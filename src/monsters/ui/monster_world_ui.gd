class_name MonsterWorldUI
extends Node3D

@export var monster: Monster

@onready var health_bar: ProgressBar = %"Health Bar"
@onready var stamina_bar: ProgressBar = %"Stamina Bar"

var tween: Tween
var is_hiding: bool

func _ready() -> void:
	monster.stat_changed.connect(_on_stat_changed)

func smooth_show() -> void:
	if not is_hiding:
		return
	is_hiding = false
	stop_if_needed()
	show()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ONE, 0.45)

func smooth_hide() -> void:
	if is_hiding:
		return
	is_hiding = true
	stop_if_needed()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.45)
	tween.tween_callback(hide)

func _on_stat_changed(target: Monster) -> void:
	if target.health > 0 and not is_visible_in_tree():
		smooth_show()
	elif target.health <= 0 and is_visible_in_tree():
		smooth_hide()

func update_stamina_progress_bar(progress: float) -> void:
	stamina_bar.value = stamina_bar.max_value * progress

func update_health_progress_bar(progress: float) -> void:
	health_bar.value = health_bar.max_value * progress

func stop_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

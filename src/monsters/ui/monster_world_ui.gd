class_name MonsterWorldUI
extends Node3D

@export var health: Health
@export var stamina: Stamina
@export var is_blocked: bool = true

@onready var health_bar: ProgressBar = %"Health Bar"
@onready var stamina_bar: ProgressBar = %"Stamina Bar"

var tween: Tween
var is_hiding: bool

func _ready() -> void:
	is_hiding = not is_visible_in_tree()
	health.changed.connect(_on_health_changed)
	stamina.changed.connect(_on_stamina_changed)

func _on_health_changed(value: Health) -> void:
	stop_if_needed()
	tween = create_tween()
	tween.tween_property(health_bar, "value", health_bar.max_value * value.get_ratio(), 0.3)
	
	if value.is_empty() and not is_hiding:
		smooth_hide()
	elif is_hiding:
		smooth_show()

func _on_stamina_changed(value: Stamina) -> void:
	stamina_bar.value = stamina_bar.max_value * value.get_ratio()

func block() -> void:
	smooth_hide()
	is_blocked = true

func unblock() -> void:
	is_blocked = false
	smooth_show()

func smooth_show() -> void:
	if not is_hiding or is_blocked:
		return
	is_hiding = false

	stop_if_needed()
	show()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ONE, 0.45).from(Vector3.ZERO)

func smooth_hide() -> void:
	if is_hiding or is_blocked:
		return
	is_hiding = true
	stop_if_needed()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.45).from(Vector3.ONE)
	tween.tween_callback(hide)

func stop_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

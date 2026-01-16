class_name MonsterWorldUI
extends Node3D

@export var health: Health
@export var stamina: Stamina

@onready var health_bar: ProgressBar = %"Health Bar"
@onready var stamina_bar: ProgressBar = %"Stamina Bar"

var tween: Tween
var is_hiding: bool

func _ready() -> void:
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

func stop_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

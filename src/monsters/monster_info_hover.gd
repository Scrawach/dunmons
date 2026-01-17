class_name MonsterInfoHover
extends Area3D

const HIGHLIGHT = preload("uid://bwl5uabgtog7a")

@export var monster: Monster

var is_hovered: bool
var highlight_tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _exit_tree() -> void:
	if is_hovered:
		Events.monster_unhover.emit(monster)

func _on_mouse_entered() -> void:
	is_hovered = true
	Events.monster_hover.emit(monster)
	highlight()

func _on_mouse_exited() -> void:
	is_hovered = false
	Events.monster_unhover.emit(monster)
	unhighlight()

func highlight() -> void:
	if monster.body == null:
		return
	monster.body.material_overlay = HIGHLIGHT
	start_smooth_highlight()

func unhighlight() -> void:
	if monster.body == null:
		return
	stop_highlight_if_needed()
	monster.body.material_overlay = null

func start_smooth_highlight() -> void:
	stop_highlight_if_needed()
	highlight_tween = create_tween()
	highlight_tween.tween_method(setup_highlight_progress, 0.0, 1.0, 0.15)

func setup_highlight_progress(value: float) -> void:
	HIGHLIGHT.set_shader_parameter("highlight_progress", value)

func stop_highlight_if_needed() -> void:
	if highlight_tween:
		highlight_tween.custom_step(9999)
		highlight_tween.kill()

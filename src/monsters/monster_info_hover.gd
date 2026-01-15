class_name MonsterInfoHover
extends Area3D

@export var monster: Monster

var is_hovered: bool

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _exit_tree() -> void:
	if is_hovered:
		Events.monster_unhover.emit(monster)

func _on_mouse_entered() -> void:
	is_hovered = true
	Events.monster_hover.emit(monster)

func _on_mouse_exited() -> void:
	is_hovered = false
	Events.monster_unhover.emit(monster)

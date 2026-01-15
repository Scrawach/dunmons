class_name MonsterInfoHover
extends Area3D

@export var monster: Monster

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	Events.monster_hover.emit(monster)

func _on_mouse_exited() -> void:
	Events.monster_unhover.emit(monster)

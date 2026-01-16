class_name Health
extends Node

signal changed(health: Health)
signal hit(damage: int)
signal healed(power: int)

@export var total: int:
	set(value):
		total = value
		changed.emit(self)

@export var current: int:
	set(value):
		current = value
		changed.emit(self)

func initialize(value: int) -> void:
	current = value
	total = value

func get_ratio() -> float:
	return float(current) / total

func is_empty() -> bool:
	return current <= 0

func take_damage(damage: int) -> void:
	current = max(0, current - damage)
	hit.emit(damage)

func heal(power: int) -> void:
	current = min(current + power, total)
	healed.emit(power)

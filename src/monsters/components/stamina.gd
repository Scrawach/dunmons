class_name Stamina
extends Node

const MAX_STAMINA: float = 1.0

signal changed(stamina: Stamina)

@export var total: float:
	set(value):
		total = value
		changed.emit(self)

@export var current: float:
	set(value):
		current = value
		changed.emit(self)

func initialize(value: float) -> void:
	current = value
	total = MAX_STAMINA

func get_ratio() -> float:
	return current / total

func is_full() -> bool:
	return get_ratio() >= MAX_STAMINA

func restore(power: float) -> void:
	current = min(current + power, total)

func consume(power: float = MAX_STAMINA) -> void:
	current = max(0, current - power)

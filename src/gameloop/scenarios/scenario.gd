class_name Scenario
extends Node

func wait_async(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

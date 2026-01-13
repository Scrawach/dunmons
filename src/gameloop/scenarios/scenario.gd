class_name Scenario
extends Node

func wait_async(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func wait_until(callable: Callable) -> void:
	while true:
		await get_tree().process_frame
		
		if callable.call():
			return

class_name TagWorldUI
extends Node3D

@export var tag_data: Tags

@onready var tag_container: TagContainer = %"Tag Container"

func initialize(tag: Tags.Type) -> void:
	tag_container.tag = tag_data.get_name_for(tag)
	tag_container.self_modulate = tag_data.get_color_for(tag)
	var random_direction = get_random_direction()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "position", position + random_direction, 0.4)
	tween.parallel().tween_property(self, "scale", Vector3.ONE, 0.3).from(Vector3.ZERO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.parallel().tween_property(tag_container, "modulate:a", 0, 0.5)
	tween.tween_callback(self.queue_free)

func get_random_direction() -> Vector3:
	var x := randf_range(-1, 1)
	var z := randf_range(-1, 1)
	return Vector3(x, 3, z)

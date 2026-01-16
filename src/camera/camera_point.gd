class_name CameraPoint
extends Node3D

@onready var camera_3d: Camera3D = $"Camera Length/Camera3D"

var tween: Tween

var base_size: float
var base_rotation: float
var base_position: Vector3

func _ready() -> void:
	base_size = camera_3d.size
	base_rotation = self.rotation.y

func move_to(target: Vector3, duration: float = 3.0) -> void:
	stop_if_needed()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", target, duration)

func zoom_to(monster: Monster, with_angle: float = 0) -> void:
	stop_if_needed()
	base_position = self.global_position
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_3d, "size", 10, 1.0)
	tween.parallel().tween_property(self, "rotation:y", deg_to_rad(with_angle), 1.0)
	tween.parallel().tween_property(self, "global_position", monster.global_position, 1.0)

func zoom_out() -> void:
	stop_if_needed()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_3d, "size", base_size, 1.0)
	tween.parallel().tween_property(self, "rotation:y", base_rotation, 1.0)
	tween.parallel().tween_property(self, "global_position", base_position, 1.0)


func stop_if_needed() -> void:
	if tween:
		tween.kill()

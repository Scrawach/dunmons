class_name DraggingArea3D
extends Area3D

signal dragged(target_position: Vector3)
signal end_dragged()

@export var body: Node3D
@export var dragging_speed: float = 50.0
@export var rotation_speed: float = 10.0

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var target_drag_position: Vector3
var is_dragging: bool

func start_drag() -> void:
	is_dragging = true

func end_drag() -> void:
	end_dragged.emit()
	is_dragging = false
	body.rotation.x = 0

func drag(target_position: Vector3) -> void:
	dragged.emit(target_position)
	target_drag_position = target_position

func enable() -> void:
	collision_shape_3d.disabled = false
	monitorable = true

func disable() -> void:
	collision_shape_3d.disabled = true
	monitorable = false
	

func _process(delta: float) -> void:
	if not is_dragging:
		return
	
	#_process_rotation(delta)
	_process_movement(delta)

func _process_rotation(delta: float) -> void:
	var direction := (target_drag_position - body.global_position).normalized()
	var target_angle := lerpf(-45, 45, (direction.z + 1) / 2)
	var step := (deg_to_rad(target_angle) - body.rotation.x)
	body.rotate_x(step * rotation_speed * delta)

func _process_movement(delta: float) -> void:
	body.global_position = body.global_position.move_toward(target_drag_position, dragging_speed * delta)

class_name DragAndDrop3D
extends Node3D

const DEPTH: float = 1000

var target: DraggingArea3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_drag"):
		start_drag(event)
	elif target == null:
		return
	elif event.is_action_released("start_drag"):
		end_drag(event)
	elif event is InputEventMouseMotion:
		drag(event)
	

func start_drag(event: InputEventMouse) -> void:
	var intersect := get_mouse_intersect(event.position)
	var dragging_area := get_first_area(intersect)
	
	if not dragging_area:
		target = null
		return
	
	target = dragging_area
	target.start_drag()

func drag(event: InputEventMouseMotion) -> void:
	target.drag(get_mouse_position_in_world_3d())

func end_drag(_event: InputEventMouse) -> void:
	target.end_drag()
	target = null

func get_mouse_position_in_world_3d() -> Vector3:
	const RAY_LENGTH := 1_000
	var mouse_position := get_viewport().get_mouse_position()
	var camera := get_viewport().get_camera_3d()
	var from := camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var plane = Plane(Vector3(1, 0, 0))
	return plane.intersects_segment(from, to)

func get_first_area(content: Dictionary) -> DraggingArea3D:
	if not content.has("collider"):
		return null
	
	return content["collider"] as DraggingArea3D

func get_mouse_intersect(mouse_position: Vector2) -> Dictionary:
	var params := make_ray_parameters(mouse_position)
	var world_3d := get_world_3d().direct_space_state
	return world_3d.intersect_ray(params)

func make_ray_parameters(mouse_position: Vector2) -> PhysicsRayQueryParameters3D:
	var camera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(mouse_position)
	params.to = camera.project_position(mouse_position, DEPTH)
	params.collide_with_areas = true
	return params

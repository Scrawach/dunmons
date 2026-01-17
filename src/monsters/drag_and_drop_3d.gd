class_name DragAndDrop3D
extends Node3D

signal dragged(area: DraggingArea3D)
signal end_dragged(arae: DraggingArea3D)

const DEPTH: float = 1000

@export var is_enabled: bool

var target: DraggingArea3D
var included_monsters: Array[Monster]

func enable() -> void:
	is_enabled = true

func disable() -> void:
	is_enabled = false

func include(monsters: Array[Monster]) -> void:
	included_monsters = monsters

func _input(event: InputEvent) -> void:
	if not is_enabled:
		return
	
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
	
	if not dragging_area.body in included_monsters:
		return
	
	target = dragging_area
	target.start_drag()
	
	var target_position = get_mouse_position_in_world_3d()
	if target_position:
		target_position.y = clampf(target_position.y, 0, 10)
		target.drag(target_position)

func drag(_event: InputEventMouseMotion) -> void:
	var target_position = get_mouse_position_in_world_3d()
	if target_position:
		target_position.y = clampf(target_position.y, 0, 10)
		target.drag(target_position)
		dragged.emit(target)

func end_drag(_event: InputEventMouse) -> void:
	target.end_drag()
	end_dragged.emit(target)
	target = null

func get_mouse_position_in_world_3d() -> Variant:
	const RAY_LENGTH := 1_000
	var mouse_position := get_viewport().get_mouse_position()
	var camera := get_viewport().get_camera_3d()
	var from := camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var plane = Plane(Vector3(0, 1, 0))
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
	const DRAGGABLE_LAYER = 1 << 1
	var camera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(mouse_position)
	params.to = camera.project_position(mouse_position, DEPTH)
	params.collide_with_areas = true
	params.collision_mask = DRAGGABLE_LAYER
	return params

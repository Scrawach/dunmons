@tool
class_name Emotion
extends Node

enum Type {
	SMILE,
	BLINK
}

@export var face: MeshInstance3D
@export var textures: Dictionary[Type, Texture2D]
@export var offset_step: int
@export var emotion: Type:
	set(new_emotion):
		emotion = new_emotion
		process(emotion)

var face_material: StandardMaterial3D

var texture_width: int
var texture_height: int

var blink_timer: Timer
var current_emotion: Type
var pause_between_blink: int

func _ready() -> void:
	if face == null:
		return
	
	face_material = face.get_active_material(0)
	texture_width = face_material.albedo_texture.get_width()
	texture_height = face_material.albedo_texture.get_height()
	
	if Engine.is_editor_hint():
		return
	
	blink_timer = Timer.new()
	add_child(blink_timer)
	blink_timer.timeout.connect(_on_blink_timeout)
	blink_timer.start(0.15)
	process(Type.SMILE)

func _on_blink_timeout() -> void:
	if pause_between_blink == 0:
		process(Type.BLINK)
		pause_between_blink = randi_range(8, 16)
	else:
		pause_between_blink -= 1
		process(Type.SMILE)

func process(type: Type) -> void:
	if face == null:
		return
	face_material.albedo_texture = textures[type]
	current_emotion = type
	#var offset := offsets[type] * offset_step
	#face_material.uv1_offset = Vector3(offset.x / texture_width, offset.y / texture_height, 0)

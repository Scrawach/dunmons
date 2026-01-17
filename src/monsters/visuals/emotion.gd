@tool
class_name Emotion
extends Node

enum Type {
	SMILE,
	BLINK,
	SAD,
	CRY,
	DEAD
}

@export var monster: Monster
@export var face: MeshInstance3D
@export var target_blink_duration: int = 2
@export var textures: Dictionary[Type, Texture2D]
@export var material: Material
@export var emotion: Type:
	set(new_emotion):
		emotion = new_emotion
		process(emotion)

var blink_timer: Timer
var blink_duration: int
var pause_between_blink: int

func _ready() -> void:
	if face == null:
		return
	
	face.material_override = material
	
	if Engine.is_editor_hint():
		return
	
	blink_timer = Timer.new()
	add_child(blink_timer)
	blink_timer.timeout.connect(_on_blink_timeout)
	blink_timer.start(0.15)
	process(Type.SMILE)
	monster.died.connect(_on_died)

func _on_died(_monster: Monster) -> void:
	process(Type.DEAD)

func _on_blink_timeout() -> void:
	match emotion:
		Type.SMILE:
			pause_between_blink -= 1
			if pause_between_blink <= 0:
				pause_between_blink = randi_range(6, 12)
				emotion = Type.BLINK
		Type.BLINK:
			blink_duration -= 1
			if blink_duration <= 0:
				blink_duration = target_blink_duration
				emotion = Type.SMILE

func process(type: Type) -> void:
	if face == null:
		return
	material.albedo_texture = textures[type]

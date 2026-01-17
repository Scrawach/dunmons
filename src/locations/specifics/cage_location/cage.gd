class_name Cage
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var monster_position: Marker3D = %"Monster Position"
@onready var escape_position: Marker3D = %"Escape Position"

var is_open: bool

func open() -> void:
	if is_open:
		return
		
	is_open = true
	animation_player.play("open")

func close() -> void:
	if not is_open:
		return
	
	is_open = false
	animation_player.play_backwards("open")

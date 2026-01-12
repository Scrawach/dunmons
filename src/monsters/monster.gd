class_name Monster
extends Node3D

signal dragged(monster: Monster)
signal end_dragged(monster: Monster)

@export var monster_name: String

@onready var dragging_area_3d: DraggingArea3D = %"Dragging Area3D"

func _ready() -> void:
	dragging_area_3d.dragged.connect(func(_pos): dragged.emit(self))
	dragging_area_3d.end_dragged.connect(func(): end_dragged.emit(self))

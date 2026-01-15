class_name MonsterInfoHover
extends Area3D

const HIGHLIGHT = preload("uid://bwl5uabgtog7a")

@export var monster: Monster
@export var body: MeshInstance3D

var highlight_material: ShaderMaterial
var is_hovered: bool

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	if body:
		highlight_material = body.get_active_material(0).next_pass

func _exit_tree() -> void:
	if is_hovered:
		Events.monster_unhover.emit(monster)

func _on_mouse_entered() -> void:
	is_hovered = true
	Events.monster_hover.emit(monster)
	highlight()

func _on_mouse_exited() -> void:
	is_hovered = false
	Events.monster_unhover.emit(monster)
	unhighlight()

func highlight() -> void:
	if body == null:
		return
	body.material_overlay = HIGHLIGHT

func unhighlight() -> void:
	if body == null:
		return
	body.material_overlay = null

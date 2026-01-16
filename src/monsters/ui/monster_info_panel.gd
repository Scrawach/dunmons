class_name MonsterInfoPanel
extends SmoothPanel

const MONSTER_HEIGHT_OFFSET: float = 85
const TAG_SCENE := preload("res://common/tags/ui/tag_container.tscn")
const TAG_DESCRIPTION_SCENE := preload("res://common/tags/ui/tag_info_panel.tscn")

@export var tags_data: Tags

@onready var tags_container: HFlowContainer = %"Tags Container"
@onready var tag_info_container: VBoxContainer = %"Tag Info Container"

@onready var name_label: Label = %"Name Label"
@onready var description_label: Label = %"Description Label"

@onready var health_progress_bar: ProgressBar = %"Health ProgressBar"
@onready var health_label: Label = %"Health Label"

@onready var attack_stat: StatContainer = %"Attack Stat"
@onready var speed_stat: StatContainer = %"Speed Stat"

var target: Monster

func initialize(monster: Monster) -> void:
	clear()
	var data := monster.data
	name_label.text = data.name
	description_label.text = data.description
	if data.attack_max != data.attack_min:
		attack_stat.text = "%s-%s" % [data.attack_min, data.attack_max]
	else:
		attack_stat.text = str(data.attack_max)
	_on_health_changed(monster.health)
	speed_stat.text = "%0.2f" % data.stamina
	add_tags(data.tags)

func attach_to(monster: Monster) -> void:
	clear()
	target = monster
	target.health.changed.connect(_on_health_changed)
	initialize(monster)
	smooth_show(0.25)
	await get_tree().process_frame
	reset_size()

func deattach() -> void:
	target.health.changed.disconnect(_on_health_changed)
	target = null
	smooth_hide(0.15)

func _on_health_changed(health: Health) -> void:
	health_progress_bar.value = health_progress_bar.max_value * health.get_ratio()
	health_label.text = "%s/%s" % [health.current, health.total]

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var viewport_position := get_viewport().get_camera_3d().unproject_position(target.global_position)
	move_to(viewport_position)

func move_to(viewport_position: Vector2) -> void:
	var center_point := size.x / 2.0
	viewport_position.x -= center_point
	viewport_position.y -= size.y + MONSTER_HEIGHT_OFFSET
	position = viewport_position
	clamp_inside_viewport()

func clamp_inside_viewport() -> void:
	var viewport_rect := get_viewport_rect()
	position.x = clamp(position.x, viewport_rect.position.x + tag_info_container.size.x, viewport_rect.size.x)
	position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.size.y - tag_info_container.size.y)

func add_tags(tags: Array[Tags.Type]) -> void:
	for tag in tags:
		var tag_name := tags_data.get_name_for(tag)
		var tag_color := tags_data.get_color_for(tag)
		var tag_description := tags_data.get_description_for(tag)
		
		add_small_tag(tag_name, tag_color)
		if not tag_description.is_empty():
			add_tag_description(tag_name, tag_color, tag_description)

func add_small_tag(tag_name: String, color: Color) -> void:
	var tag_instance := TAG_SCENE.instantiate() as TagContainer
	tags_container.add_child(tag_instance)
	tag_instance.tag = tag_name
	tag_instance.self_modulate = color

func add_tag_description(tag_name: String, color: Color, description: String) -> void:
	var description_instance := TAG_DESCRIPTION_SCENE.instantiate() as TagInfoPanel
	tag_info_container.add_child(description_instance)
	description_instance.tag_name = tag_name
	description_instance.tag_color = color
	description_instance.tag_description = description

func clear() -> void:
	reset_size()
	for child in tags_container.get_children():
		child.queue_free()
	for child in tag_info_container.get_children():
		child.queue_free()

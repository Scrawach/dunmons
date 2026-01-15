class_name MonsterInfoPanel
extends PanelContainer

const MONSTER_HEIGHT_OFFSET: float = 85
const TAG_SCENE := preload("res://common/tags/ui/tag_container.tscn")
const TAG_DESCRIPTION_SCENE := preload("res://common/tags/ui/tag_info_panel.tscn")

@export var tags_data: Tags

@onready var tags_container: HFlowContainer = %"Tags Container"
@onready var tag_info_container: VBoxContainer = %"Tag Info Container"

@onready var name_label: Label = %"Name Label"
@onready var description_label: Label = %"Description Label"

@onready var attack_stat: StatContainer = %"Attack Stat"
@onready var health_stat: StatContainer = %"Health Stat"
@onready var speed_stat: StatContainer = %"Speed Stat"

func initialize(data: MonsterInfo) -> void:
	clear()
	name_label.text = data.name
	description_label.text = data.description
	attack_stat.text = str(data.attack)
	health_stat.text = str(data.health)
	speed_stat.text = str(data.speed)
	add_tags(data.tags)

func move_to(viewport_position: Vector2) -> void:
	var center_point := size.x / 2.0
	viewport_position.x -= center_point
	viewport_position.y -= size.y + MONSTER_HEIGHT_OFFSET
	position = viewport_position
	pass

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
	for child in tags_container.get_children():
		child.queue_free()
	for child in tag_info_container.get_children():
		child.queue_free()

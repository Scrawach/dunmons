@tool
class_name TagInfoPanel
extends PanelContainer

@export var tag_name: String:
	set(new_tag_name):
		tag_name = new_tag_name
		if not is_node_ready(): await ready
		%"Tag Container".tag = new_tag_name

@export var tag_color: Color:
	set(new_tag_color):
		tag_color = new_tag_color
		if not is_node_ready(): await ready
		%"Tag Container".self_modulate = new_tag_color

@export var tag_description: String:
	set(new_tag_description):
		tag_description = new_tag_description
		if not is_node_ready(): await ready
		%Description.text = new_tag_description

@tool
class_name TagContainer
extends PanelContainer

@export var tag: String:
	set(new_tag):
		tag = new_tag
		if not is_node_ready(): await ready
		%Label.text = new_tag

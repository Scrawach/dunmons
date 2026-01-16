@tool
class_name StatContainer
extends PanelContainer

@export var icon: Texture2D:
	set(new_icon):
		icon = new_icon
		if not is_node_ready(): await ready
		%Texture.texture = icon

@export var text: String:
	set(new_text):
		text = new_text
		if not is_node_ready(): await ready
		%Label.text = new_text

@export var progress: float = 1.0:
	set(new_progress):
		progress = new_progress

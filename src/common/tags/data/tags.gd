class_name Tags
extends Resource

enum Type {
	NORMAL = 0,
	FIRE = 1,
	WATER = 2,
	STONE = 3,
	GRASS = 4,
	GUARD = 100,
}

@export var colors: Dictionary[Type, Color]
@export var descriptions: Dictionary[Type, String]
@export var materials: Dictionary[Type, Material]

func get_elemental_tags() -> Array[Type]:
	return [
		Type.FIRE, Type.WATER, Type.STONE
	]

func get_name_for(tag: Type) -> String:
	return Tags.Type.find_key(tag)

func get_material_for(tag: Type) -> Material:
	if not materials.has(tag):
		return null
	
	return materials[tag]

func get_color_for(tag: Type) -> Color:
	if not colors.has(tag):
		return Color.PURPLE
	return colors[tag]

func get_description_for(tag: Type) -> String:
	if not descriptions.has(tag):
		return ""
	return descriptions[tag]

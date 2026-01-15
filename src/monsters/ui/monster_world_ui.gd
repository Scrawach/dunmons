class_name MonsterWorldUI
extends Sprite3D

@onready var stamina_progress_handle: Control = %"Stamina Progress Handle"
@onready var stamina_progress_bar: Control = %"Stamina Progress Bar"

func update_stamina_progress_bar(progress: float) -> void:
	var target_size := stamina_progress_handle.size.x * clampf(progress, 0, 1)
	stamina_progress_bar.size.x = target_size

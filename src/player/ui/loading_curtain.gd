class_name LoadingCurtain
extends CanvasLayer

@onready var curtain: ColorRect = %Curtain

var tween: Tween

func prepare_material(is_showing: bool) -> void:
	var material := curtain.material as ShaderMaterial
	material.set_shader_parameter(&"is_open", 1.0 if is_showing else -1.0)
	material.set_shader_parameter(&"progress", 0.0)

func update_progress(progress: float) -> void:
	var material := curtain.material as ShaderMaterial
	material.set_shader_parameter(&"progress", progress)

func smooth_show(callback: Callable = Callable()) -> void:
	_stop_if_needed()
	prepare_material(true)
	tween = create_tween()
	tween.tween_method(update_progress, 0.0, 1.0, 0.8)
	tween.tween_callback(callback)

func smooth_hide(callback: Callable = Callable()) -> void:
	_stop_if_needed()
	prepare_material(false)
	tween = create_tween()
	tween.tween_method(update_progress, 0.0, 1.0, 0.8)
	tween.tween_callback(callback)

func _stop_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

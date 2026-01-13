class_name PlayerHUD
extends CanvasLayer

@export var appear_duration: float = 0.4

@onready var dialogue_panel: DialoguePanel = %"Dialogue Panel"
@onready var naming_panel: NamingPanel = %"Naming Panel"
@onready var background: PanelContainer = %Background

var background_tween: Tween
var appear_tween: Tween

func show_dialogue(message: String) -> void:
	dialogue_panel.smooth_show()
	dialogue_panel.show_message(message)
	
func hide_dialogue() -> void:
	dialogue_panel.smooth_hide()

func show_naming() -> void:
	naming_panel.smooth_show()

func hide_naming() -> void:
	naming_panel.smooth_hide()

func show_background() -> void:
	background_tween = create_tween()
	background_tween.tween_property(background, "modulate:a", 0.2, 0.5).from(0)

func hide_background() -> void:
	background_tween = create_tween()
	background_tween.tween_property(background, "modulate:a", 0, 0.5).from_current()

func _stop_tween_if_needed(target: Tween) -> void:
	if target:
		target.custom_step(9999)
		target.kill()

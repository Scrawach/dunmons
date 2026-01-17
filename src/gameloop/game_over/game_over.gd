class_name GameOver
extends Scenario

@export var hud: PlayerHUD
@export var loading_curtain: LoadingCurtain

func execute() -> void:
	var game_over_panel := hud.show_game_over()
	await game_over_panel.restart_button.pressed
	loading_curtain.smooth_show(_restart)

func _restart() -> void:
	get_tree().reload_current_scene()

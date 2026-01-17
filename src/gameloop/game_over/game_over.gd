class_name GameOver
extends Scenario

@export var hud: PlayerHUD

func execute() -> void:
	hud.show_game_over()

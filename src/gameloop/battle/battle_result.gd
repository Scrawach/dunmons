class_name BattleResult
extends RefCounted

var is_enemy_won: bool

static func player_win() -> BattleResult:
	var result := BattleResult.new()
	return result

static func enemy_win() -> BattleResult:
	var result := BattleResult.new()
	result.is_enemy_won = true
	return result

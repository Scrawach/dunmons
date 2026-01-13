class_name BattleResult
extends RefCounted

var is_player_win: bool

static func player_win() -> BattleResult:
	var result := BattleResult.new()
	result.is_player_win = true
	return result

static func enemy_win() -> BattleResult:
	var result := BattleResult.new()
	return result

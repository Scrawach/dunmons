class_name Battle
extends Scenario

var player_monsters: MonsterLine
var enemy_monsters: MonsterLine

var fighters: Array[MonsterLine]

func setup(player: MonsterLine, enemy: MonsterLine) -> void:
	player_monsters = player
	enemy_monsters = enemy
	fighters = [player, enemy]

func execute_async() -> BattleResult:
	var fighter_id: int = 0
	
	while player_monsters.has_creatures() and enemy_monsters.has_creatures():
		var fighter := fighters[fighter_id]
		print("fighter #%s make turn" % fighter_id)
		fighter_id += 1
		fighter_id %= fighters.size()
		
		await wait_async(0.5)
		await make_turn_async(fighter, fighters[fighter_id])
	
	if player_monsters.has_creatures():
		return BattleResult.player_win()
	else:
		return BattleResult.enemy_win()

func make_turn_async(mine: MonsterLine, enemy: MonsterLine) -> void:
	var unit := mine.get_first()
	var target := enemy.get_first()
	await unit.attack_async(enemy.get_first())
	await target.take_damage_async(unit.damage)

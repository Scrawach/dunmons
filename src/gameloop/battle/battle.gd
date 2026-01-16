class_name Battle
extends Scenario

@export var tick_duration: float = 0.1
@export var camera_point: CameraPoint

func simulate_async(player: MonsterLine, enemies: MonsterLine) -> BattleResult:
	while player.has_creatures() and enemies.has_creatures():
		var player_monster := player.get_first()
		var enemy_monster := enemies.get_first()
		player_monster.monster_world_ui.unblock()
		enemy_monster.monster_world_ui.unblock()
		
		player_monster.health.hit.connect(_on_monster_hit)
		enemy_monster.health.hit.connect(_on_monster_hit)
		while not player_monster.is_death and not enemy_monster.is_death:
			await wait_async(tick_duration)
			player_monster.restore_stamine(tick_duration)
			enemy_monster.restore_stamine(tick_duration)
			
			if player_monster.can_attack():
				await process_attack(player_monster, enemy_monster)
			
			if enemy_monster.can_attack():
				await process_attack(enemy_monster, player_monster)
		player_monster.health.hit.disconnect(_on_monster_hit)
		enemy_monster.health.hit.disconnect(_on_monster_hit)
		
	
	for monster in player.monsters:
		monster.monster_world_ui.block()
	
	for monster in enemies.monsters:
		monster.monster_world_ui.block()
	
	if player.has_creatures():
		return BattleResult.player_win()
	
	return BattleResult.enemy_win()

func process_attack(attacker: Monster, target: Monster) -> void:
	await attacker.attack_async(target)
	await target.take_damage_async(5)

func _on_monster_hit(power: int) -> void:
	camera_point.shake(power * 0.1)

class_name Battle
extends Scenario

const TARGET_SCENE := preload("uid://s3jr88n1yai7")
const COIN_SCENE := preload("uid://xi70be5hasug")

@export var tick_duration: float = 0.1
@export var camera_point: CameraPoint
@export var wallet: PlayerWallet

var player_target: TargetCircle
var enemy_target: TargetCircle

func _ready() -> void:
	player_target = TARGET_SCENE.instantiate() as TargetCircle
	enemy_target = TARGET_SCENE.instantiate() as TargetCircle
	add_child(player_target)
	add_child(enemy_target)
	player_target.hide()
	enemy_target.hide()

func simulate_async(player: MonsterLine, enemies: MonsterLine) -> BattleResult:
	while player.has_creatures() and enemies.has_creatures():
		var player_monster := player.get_first()
		var enemy_monster := enemies.get_first()
		player_monster.monster_world_ui.unblock()
		enemy_monster.monster_world_ui.unblock()
		
		player_monster.health.hit.connect(_on_monster_hit)
		enemy_monster.health.hit.connect(_on_monster_hit)
		
		player_target.show_under(player_monster)
		enemy_target.show_under(enemy_monster)
		
		while not player_monster.is_death and not enemy_monster.is_death:
			await wait_async(tick_duration)
			player_monster.restore_stamine(tick_duration)
			enemy_monster.restore_stamine(tick_duration)
			
			if player_monster.can_attack():
				await process_attack(player_monster, enemy_monster)
				
			if enemy_monster.can_attack():
				await process_attack(enemy_monster, player_monster)
			
			if enemy_monster.is_death:
				await spawn_drop(enemy_monster)
				
		player_monster.health.hit.disconnect(_on_monster_hit)
		enemy_monster.health.hit.disconnect(_on_monster_hit)
	
	enemy_target.smooth_hide()
	player_target.smooth_hide()
	
	for monster in player.monsters:
		monster.monster_world_ui.block()
	
	for monster in enemies.monsters:
		monster.monster_world_ui.block()
	
	if player.has_creatures():
		return BattleResult.player_win()
	
	return BattleResult.enemy_win()

func process_attack(attacker: Monster, target: Monster) -> void:
	await attacker.attack_async(target)
	var damage := calculate_damage(attacker, target)
	await target.take_damage_async(damage)

func calculate_damage(attacker: Monster, target: Monster) -> int:
	var base_damage := randi_range(attacker.damage_min, attacker.damage_max)
	return base_damage

func spawn_drop(target: Monster) -> void:
	const COINS := 1
	var instance := COIN_SCENE.instantiate() as Coin3D
	add_child(instance)
	instance.global_position = target.global_position
	instance.launch(COINS)
	wallet.add(COINS)
	await wait_async(0.5)

func _on_monster_hit(power: int) -> void:
	camera_point.shake(power * 0.1)

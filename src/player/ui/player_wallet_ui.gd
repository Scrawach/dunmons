class_name PlayerWalletUI
extends PanelContainer

@export var player_wallet: PlayerWallet

@onready var value_label: Label = %"Value Label"
@onready var add_label: Label = %"Add Label"

var tween: Tween
var value_tween: Tween

func _ready() -> void:
	player_wallet.changed.connect(_on_wallet_changed)
	player_wallet.added.connect(_on_coins_added)
	sync_with_wallet(player_wallet)

func _on_wallet_changed(wallet: PlayerWallet) -> void:
	if is_visible_in_tree():
		return
	
	show()
	var showing := create_tween()
	showing.tween_property(self, "modulate:a", 1.0, 0.5).from(0)

func _on_coins_added(value: int) -> void:
	add_label.text = "+%s" % value
	
	stop_if_needed()
	tween = create_tween()

	value_label.pivot_offset = value_label.size / 2.0
	value_tween = create_tween()
	value_tween.tween_property(value_label, "scale", Vector2.ONE * 1.5, 0.1)
	value_tween.tween_callback(func(): value_label.text = str(player_wallet.total))
	value_tween.tween_property(value_label, "scale", Vector2.ONE, 0.07)
	value_tween.stop()
	
	add_label.pivot_offset = add_label.size / 2.0
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(add_label, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(add_label, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
	tween.parallel().tween_subtween(value_tween)
	tween.parallel().tween_interval(1.0)
	tween.tween_property(add_label, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(add_label, "scale", Vector2.ZERO, 0.5)

func sync_with_wallet(wallet: PlayerWallet) -> void:
	value_label.text = str(wallet.total)

func stop_if_needed() -> void:
	if tween:
		tween.custom_step(9999)
		tween.kill()

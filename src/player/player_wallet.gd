class_name PlayerWallet
extends Node

signal changed(wallet: PlayerWallet)
signal added(value: int)
signal removed(value: int)

var total: int:
	set(value):
		total = value
		changed.emit(self)

func can_purchase(price: int) -> bool:
	return total >= price

func add(coins: int) -> void:
	total += coins
	added.emit(coins)

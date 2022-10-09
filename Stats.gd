extends Node

export var MAX_HEALTH = 100 setget set_max_health
export var MAX_STAMINA = 100 setget set_max_stamina
export var SAVED_MONEY = 0 setget set_total_money
var health = MAX_HEALTH setget set_health
var stamina = MAX_STAMINA setget set_stamina
var money = SAVED_MONEY setget set_money

signal no_health
signal no_stamina
signal health_changed(value)
signal stamina_changed(value)
signal money_changed(value)
signal max_health_changed(value)
signal max_stamina_changed(value)
signal total_money_changed(value)


func _ready():
	self.health = MAX_HEALTH
	self.stamina = MAX_STAMINA

func set_max_health(value):
	MAX_HEALTH = value
	self.health = min(health, MAX_HEALTH)
	emit_signal("max_health_changed", MAX_HEALTH)

func set_max_stamina(value):
	MAX_STAMINA = value
	self.stamina = min(stamina, MAX_STAMINA)
	emit_signal("max_stamina_changed", MAX_STAMINA)

func set_total_money(value):
	SAVED_MONEY = value
	self.money = min(money, SAVED_MONEY)
	emit_signal("total_money_changed", SAVED_MONEY)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_stamina(value):
	stamina = value
	emit_signal("stamina_changed", stamina)
	if stamina <= 0:
		stamina = 0
		emit_signal("no_stamina")

func set_money(value):
	money = value
	emit_signal("money_changed", money)
	



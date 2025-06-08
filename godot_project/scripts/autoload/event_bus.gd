class_name GEventBus
extends Node

var killAllEnemies: bool = false :
	get():
		return killAllEnemies
	set(value):
		killAllEnemies = value

signal enemy_created()
signal enemy_died()

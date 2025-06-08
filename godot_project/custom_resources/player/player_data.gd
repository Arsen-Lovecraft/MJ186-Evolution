class_name RplayerData
extends Resource

signal dead()
signal levelUp

@export var playerLevel : int = 1
@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -400.0
@export var mp_regen_rate : float = 10.0
@export var gravity :Vector2 = Vector2(0.0,980.0)
@export var max_hp: float = 100
@export var hp: float = 100:
	set(value):
		if(value > max_hp):
			hp = max_hp
		else:
			hp = value
		if(hp <= 0):
			dead.emit()
@export var max_mp: float = 100
@export var mp: float = 0:
	get:
		return mp
	set(value):
		if(value > 0):
			mp = value
		elif(mp >= max_mp):
			max_mp*=1.7
			levelUp.emit()
@export var damage: float = 100
@export var attack_cooldown: float = 1.0

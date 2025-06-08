class_name RplayerData
extends Resource

signal dead()
signal levelUp

@export var playerLevel : int = 1
@export var playerMprate : float = 50.0
@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -400.0
@export var regen_rate : float = 1.0
@export var mp_regen_rate : float = 2.0
@export var gravity :Vector2 = Vector2(0.0,980.0)

@export var hp: float = 100:
	set(value):
		hp = value
		if(hp <= 0):
			dead.emit()
@export var mp: float = 50:
	get:
		return mp
	set(value):
		mp = value
		if(mp >= 100):
			levelUp.emit()
			
@export var damage: float = 100
@export var attack_cooldown: float = 1.0

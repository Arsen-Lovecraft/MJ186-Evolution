class_name RMeleeEnemy
extends Resource

signal dead()

@export var hp: float = 100:
	set(value):
		hp = value
		if(hp == 0):
			dead.emit()
@export var speed: float = 100
@export var damage: float = 100
@export var attack_cooldown: float = 1.0

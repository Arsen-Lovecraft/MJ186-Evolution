class_name RMeleeEnemy
extends Resource

signal dead()

@export var hp_to_level: Curve
@export var speed_to_level: Curve
@export var damage_to_level: Curve
@export var attack_cooldown_to_level: Curve

var hp: float = 100:
	set(value):
		hp = value
		if(hp <= 0):
			dead.emit()
var speed: float = 100
var damage: float = 100
var attack_cooldown: float = 1.0

var lvl: int = 1

func set_level(_lvl: int = 1) -> void:
	lvl = _lvl
	hp = hp_to_level.get_point_position(lvl-1).y
	speed = speed_to_level.get_point_position(lvl-1).y
	damage = damage_to_level.get_point_position(lvl-1).y
	attack_cooldown = attack_cooldown_to_level.get_point_position(lvl-1).y

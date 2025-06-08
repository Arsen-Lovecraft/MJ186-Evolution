class_name Spawner
extends Node2D

const MELEE_ENEMY_PS: PackedScene = preload("uid://darlr5ccm4gj3")
const RANGE_ENEMY_PS: PackedScene = preload("uid://dbs7qyg8efv27")
const ENEMY_MELEE_DATA: RMeleeEnemy = preload("uid://udmqedg7r0nf")
const ENEMY_RANGE_DATAL: RRangeEnemy = preload("uid://d2rur8re0oq04")

@onready var _spawner_animation_player: AnimationPlayer = %SpawnerAnimationPlayer

var melee_queue: Array[int]
var range_queue: Array[int]

func _ready() -> void:
	_spawner_animation_player.animation_finished.connect(_on_animation_finished)
	print(_spawner_animation_player.name)

func spawn_melee(lvl: int = 1) -> void:
	if(_spawner_animation_player.is_playing()):
		melee_queue.push_back(lvl)
	var melee_inst: MeleeEnemy = MELEE_ENEMY_PS.instantiate()
	var data: RMeleeEnemy = ENEMY_MELEE_DATA.duplicate(true)
	data.set_level(lvl)
	melee_inst.load_data(data)
	melee_inst.global_position = self.global_position
	_spawner_animation_player.play("open")
	await _spawner_animation_player.animation_finished
	get_tree().current_scene.add_child(melee_inst)
	_spawner_animation_player.play("close")

func spawn_range(lvl: int = 1) -> void:
	if(_spawner_animation_player.is_playing()):
		range_queue.push_back(lvl)
	var range_inst: RangeEnemy = RANGE_ENEMY_PS.instantiate()
	var data: RRangeEnemy = ENEMY_RANGE_DATAL.duplicate(true)
	data.set_level(lvl)
	range_inst.load_data(data)
	range_inst.global_position = self.global_position
	_spawner_animation_player.play("open")
	await _spawner_animation_player.animation_finished
	get_tree().current_scene.add_child(range_inst)
	_spawner_animation_player.play("close")

func _on_animation_finished(anim_name: String) -> void:
	if(anim_name == "close"):
		if(melee_queue.size() != 0):
			spawn_melee(melee_queue.pop_front())
			return
		if(range_queue.size() != 0):
			spawn_range(range_queue.pop_front())
			return

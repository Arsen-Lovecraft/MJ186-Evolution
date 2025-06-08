class_name Spawner
extends Node2D

const MELEE_ENEMY_PS: PackedScene = preload("uid://darlr5ccm4gj3")
const RANGE_ENEMY_PS: PackedScene = preload("uid://dbs7qyg8efv27")
const ENEMY_MELEE_DATA: RMeleeEnemy = preload("uid://udmqedg7r0nf")
const ENEMY_RANGE_DATAL: RRangeEnemy = preload("uid://d2rur8re0oq04")

@onready var _spawner_animation_player: AnimationPlayer = %SpawnerAnimationPlayer

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("punch")):
		var lvl: int = randi_range(1,12)
		var type: int = randi_range(1,2)
		if(type == 1):
			spawn_melee(lvl)
		else:
			spawn_range(lvl)

func spawn_melee(lvl: int = 1) -> void:
	if(_spawner_animation_player.is_playing()):
		await _spawner_animation_player.animation_finished
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
		await _spawner_animation_player.animation_finished
	await _spawner_animation_player.animation_finished
	var range_inst: RangeEnemy = RANGE_ENEMY_PS.instantiate()
	var data: RRangeEnemy = ENEMY_RANGE_DATAL.duplicate(true)
	data.set_level(lvl)
	range_inst.load_data(data)
	range_inst.global_position = self.global_position
	_spawner_animation_player.play("open")
	await _spawner_animation_player.animation_finished
	get_tree().current_scene.add_child(range_inst)
	_spawner_animation_player.play("close")

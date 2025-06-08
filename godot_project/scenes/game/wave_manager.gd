class_name WaveManager
extends Node

@onready var _spawners_container: Node2D = %Spawners

var _spawners: Array[Spawner]

var _waves_spawn_dictionary: Dictionary[int, WaveDescription] = {
	1: preload("uid://b7mu6o6h6tk4o"),
	2: preload("uid://ck4syvx7xx5wx"),
	3: preload("uid://yq5tmt881yay"),
	4: preload("uid://7e8irr8e78ui"),
	5: preload("uid://0vog7klkgxxa"),
	6: preload("uid://culvwgvg1et0c"),
	7: preload("uid://046tdf7738qi"),
	8: preload("uid://bbkuep0jlopk0"),
	9: preload("uid://dqy8vqvbpxk8c"),
	10: preload("uid://dwux0l1ojx0og"),
	11: preload("uid://bybd3dqdsy2h5"),
	12: preload("uid://jkt2yciwsxvq")}


func _ready() -> void:
	for i: Spawner in _spawners_container.get_children():
		_spawners.push_back(i)

func spawn_enemies(wave: int) -> void:
	while(true):
		var melee_lvl_to_spawn: int = _waves_spawn_dictionary[wave].get_lvl_melee_to_spawn()
		if(melee_lvl_to_spawn == 0):
			break
		(_spawners.pick_random() as  Spawner).spawn_melee(melee_lvl_to_spawn)
	while(true):
		var range_lvl_to_spawn: int = _waves_spawn_dictionary[wave].get_lvl_range_to_spawn()
		if(range_lvl_to_spawn == 0):
			break
		(_spawners.pick_random() as  Spawner).spawn_range(range_lvl_to_spawn)

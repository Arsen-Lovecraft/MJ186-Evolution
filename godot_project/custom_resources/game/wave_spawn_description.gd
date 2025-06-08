class_name WaveDescription
extends Resource

@export var melee_spawn_lvl_to_quantity: Dictionary [int,int] = {
	1:0,
	2:0,
	3:0,
	4:0,
	5:0,
	6:0,
	7:0,
	8:0,
	9:0,
	10:0,
	11:0,
	12:0,
}
@export var range_spawn_lvl_to_quantity: Dictionary [int,int] = {
	1:0,
	2:0,
	3:0,
	4:0,
	5:0,
	6:0,
	7:0,
	8:0,
	9:0,
	10:0,
	11:0,
	12:0,
}

func get_lvl_melee_to_spawn() -> int:
	for i: int in melee_spawn_lvl_to_quantity:
		if(melee_spawn_lvl_to_quantity[i] != 0):
			melee_spawn_lvl_to_quantity[i] -= 1
			return i
	return 0

func get_lvl_range_to_spawn() -> int:
	for i: int in range_spawn_lvl_to_quantity:
		if(range_spawn_lvl_to_quantity[i] != 0):
			range_spawn_lvl_to_quantity[i] -= 1
			return i
	return 0

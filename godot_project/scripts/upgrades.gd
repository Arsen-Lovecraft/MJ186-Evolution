extends CanvasLayer
class_name Upgrades

@export var _upgrade_list : UpgradeList = preload("uid://b07tteevgv41w")
@export var _player : RplayerData = preload("uid://byrd0re6gadg6")

@onready var upgrade_1: Button = %Upgrade1
@onready var upgrade_2: Button = %Upgrade2
var _upgrades : Dictionary

var pair: Array

func _ready() -> void:
	_upgrades = get_exported_variables(_upgrade_list)
	pair = get_two_unique_random_values (_upgrades)
	_update_upgrade_button_text(pair)
	call_deferred("_connect_button_signals", pair)
	
func _update_upgrade_button_text(pair: Array) -> void:
		
	var pair1 :Variant= rename_keys(pair[0])
	var pair2 :Variant= rename_keys(pair[1])
	
	
	upgrade_1.text = "Kill all enemies" if str(pair1.keys()[0]) == "Kill all enemies" else "Increase " + str(pair1.keys()[0]) + " by " + str(pair1.values()[0])
	upgrade_2.text = "Kill all enemies" if str(pair2.keys()[0]) == "Kill all enemies" else "Increase " + str(pair2.keys()[0]) + " by " + str(pair2.values()[0])
	
func _connect_button_signals(pair: Array) -> void:

	upgrade_1.connect("pressed", Callable(self, "_upgrade_chosen1").bind(pair[0]))
	upgrade_2.connect("pressed", Callable(self, "_upgrade_chosen2").bind(pair[1]))
	
func get_exported_variables(res: Resource) -> Dictionary:
	var data := {}
	for prop in res.get_property_list():
		if prop.usage & PROPERTY_USAGE_STORAGE != 0 and prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			data[prop.name] = res.get(prop.name)
	return data
	
func get_two_unique_random_values(dict: Dictionary) -> Array:
	randomize()
	
	var keys := dict.keys()
	if keys.size() < 2:
		push_error("Not enough unique entries in dictionary!")
		return []
	# Shuffle keys and pick first two
	keys.shuffle()
	var key1 :Variant= keys[0]
	var key2 :Variant= keys[1]

	var pair1 :Variant= {key1: dict[key1]}
	var pair2 :Variant= {key2: dict[key2]}
	
	return [pair1, pair2]
	
func rename_keys(dict: Dictionary) -> Dictionary:
	var new_dict := {}
	for key:String in dict.keys():
		match key:
			"jump_increase":
				var value : Variant = dict[key]
				new_dict["Jump"] = value
			"damage_increase":
				var value : Variant = dict[key]
				new_dict["Damage"] = value
			"speed_increase":
				var value : Variant = dict[key]
				new_dict["Speed"] = value
	return new_dict

func _upgrade_chosen1(pair: Dictionary) -> void:
	for key:String in pair.keys():
		print(pair[key])
		match key:
			"jump_increase":
				_player.JUMP_VELOCITY -= pair[key]
			"damage_increase":
				_player.damage += pair[key]
			"speed_increase":
				_player.SPEED += pair[key]
	get_tree().paused = false
	queue_free()
	
func _upgrade_chosen2(pair: Dictionary) -> void:
	for key:String in pair.keys():
		print(pair[key])
		match key:
			"jump_increase":
				_player.JUMP_VELOCITY -= pair[key]
			"damage_increase":
				_player.damage += pair[key]
			"speed_increase":
				_player.SPEED += pair[key]
	get_tree().paused = false
	queue_free()

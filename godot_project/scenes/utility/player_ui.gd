extends CanvasLayer
class_name PlayerUI

@onready var player_hp: TextureProgressBar = %playerHP
@onready var player_mp: TextureProgressBar = %playerMP
@export var _player_data: RplayerData
@onready var _hp_count: Label = %HPCount
@onready var _mp_count: Label = %MPCount

func _process(_delta: float) -> void:
	player_hp.value = _player_data.hp
	player_hp.max_value = _player_data.max_hp
	player_mp.value = _player_data.mp
	player_mp.max_value = _player_data.max_mp
	_hp_count.text = str(int(_player_data.hp)) + "/" + str(int(_player_data.max_hp))
	_mp_count.text = str(int(_player_data.mp)) + "/" + str(int(_player_data.max_mp))

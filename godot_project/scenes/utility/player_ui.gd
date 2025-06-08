extends CanvasLayer
class_name PlayerUI

@onready var player_hp: TextureProgressBar = %playerHP
@onready var player_mp: TextureProgressBar = %playerMP
@export var _player_data: RplayerData

func _process(_delta: float) -> void:
	player_hp.value = _player_data.hp
	player_mp.value = _player_data.mp

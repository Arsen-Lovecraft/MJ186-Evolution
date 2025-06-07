extends CanvasLayer
class_name PlayerUI

@onready var player_hp: TextureProgressBar = %playerHP
@onready var player_mp: TextureProgressBar = %playerMP

func _process(_delta: float) -> void:
	player_hp.value = Global.playerHP
	player_mp.value = Global.playerMP

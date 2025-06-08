extends Node2D

@onready var player: Player = %Player


func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	player.connect("gameOver",_game_over)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false

func _game_over() -> void:
	print("over")

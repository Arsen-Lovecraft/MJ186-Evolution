class_name  GameMode
extends Node

const SETTINGS_UI_PS: PackedScene = preload("uid://ldg2jq7gg87x")
@onready var _wave_manager: WaveManager = %WaveManager
@onready var next_wave: int =  1
@onready var player: Player = %Player
@onready var bg_music: AudioStreamPlayer = %BGMusic

var enemy_count: int = 0:
	set(value):
		enemy_count = value
		if(enemy_count == 0):
			_wave_manager.spawn_enemies(next_wave)
			next_wave+=1
			EventBus.killAllEnemies = false

func  _ready() -> void:
	_connect_signals()
	_wave_manager.spawn_enemies(next_wave)
	next_wave+=1
	EventBus.startGame = false
	

func _connect_signals() -> void:
	EventBus.enemy_created.connect(_on_enemy_created)
	EventBus.enemy_died.connect(_on_enemy_died)
	player.connect("gameOver",_game_over)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().current_scene.add_child(SETTINGS_UI_PS.instantiate())
	if EventBus.startGame == true:
		bg_music.play()


func _on_enemy_created() -> void:
	enemy_count+=1

func _on_enemy_died() -> void:
	enemy_count-=1

func _game_over() -> void:
	get_tree().quit()

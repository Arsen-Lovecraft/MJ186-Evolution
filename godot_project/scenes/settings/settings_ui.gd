class_name SettingsWindows
extends CanvasLayer

@onready var _exit_button: Button = %ExitButton
@onready var start_game: Button = %startGame
@onready var end_game: Button = %endGame
@onready var menu_music: AudioStreamPlayer = %MenuMusic
@onready var settings: SettingsWindows = %settings


var _prev_mouse_capture_mode: Input.MouseMode

func _ready() -> void:
	_connect_signals()
	_prev_mouse_capture_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	menu_music.play()


func _connect_signals() -> void:
	if _exit_button.pressed.connect(_on_pressed_exited): printerr("Fail: ",get_stack())
	start_game.connect("pressed", _start_game)

func _start_game() -> void:
	get_tree().paused = false
	EventBus.startGame = true
	queue_free()


func _on_pressed_exited() -> void:
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_capture_mode
	queue_free()

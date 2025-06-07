class_name MeleeEnemy
extends CharacterBody2D

@onready var _sensor: Area2D = %Sensor
@onready var _me_animation_player: AnimationPlayer = %MEAnimationPlayer
@onready var _damage_zones: Area2D = %DamageZones
@onready var _is_player_detected: bool = false
@onready var _is_move_to_right: bool = true
@onready var _ray_cast_2d_right: RayCast2D = %RayCast2DRight
@onready var _ray_cast_2d_2_left: RayCast2D = %RayCast2D2Left

func _ready() -> void:
	add_to_group("enemies")
	velocity.y = 9.8
	_connect_signals()

func _physics_process(delta: float) -> void:
	if(_ray_cast_2d_2_left.is_colliding() == false):
		_is_move_to_right = true
	if(_ray_cast_2d_right.is_colliding() == false):
		_is_move_to_right = false
	if(_is_player_detected and _me_animation_player.current_animation != "attack"):
		_move_to_player((get_tree().get_first_node_in_group("Player") as Player).global_position)
	elif(_me_animation_player.current_animation != "attack"):
		_auto_move()
	_handle_animations()
	move_and_slide()

func _connect_signals() -> void:
	_sensor.body_entered.connect(_on_player_detected)
	_sensor.body_exited.connect(_on_player_undetected)
	_damage_zones.body_entered.connect(_on_player_in_damage_area)
	_me_animation_player.animation_finished.connect(_on_animation_finished)

func _handle_animations() -> void:
	if(velocity.x > 0):
		_me_animation_player.play("move_right")
	elif(velocity.x < 0):
		_me_animation_player.play("move_left")

func _auto_move() -> void:
	if(_is_move_to_right):
		velocity.x = 100
	else:
		velocity.x = -100

func _move_to_player(global_pos: Vector2) -> void:
	var direction: Vector2 = (global_pos - self.global_position).normalized()
	if(direction.x > 0 and _ray_cast_2d_right.is_colliding() == true):
		velocity.x = 100
		_is_move_to_right = true
	elif(direction.x < 0 and _ray_cast_2d_2_left.is_colliding() == true):
		velocity.x = -100
		_is_move_to_right = false
	else:
		velocity.x = 0

func _attack() -> void:
	velocity.x = 0
	_me_animation_player.play("attack")

func _try_to_damage() -> void:
	##Resource
	for body: Node2D in _damage_zones.get_overlapping_bodies():
		if(body is Player):
			EventBus.player_hitted.emit(1000)

func _on_player_detected(body: Node2D) -> void:
	if(body is Player):
		_is_player_detected = true

func _on_player_undetected(body: Node2D) -> void:
	if(body is Player):
		_is_player_detected = false

func _on_player_in_damage_area(body: Node2D) -> void:
	if(body is Player):
		_attack()

func _on_animation_finished(animation_name: String) -> void:
	if(animation_name == "death"):
		queue_free()
	elif(animation_name == "attack"):
		_me_animation_player.play("RESET")

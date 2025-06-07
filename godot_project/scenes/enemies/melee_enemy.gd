class_name MeleeEnemy
extends CharacterBody2D

@onready var _sensor: Area2D = %Sensor
@onready var _me_animation_player: AnimationPlayer = %MEAnimationPlayer
@onready var _damage_zones: Area2D = %DamageZones
@onready var _ray_cast_2d_right: RayCast2D = %RayCast2DRight
@onready var _ray_cast_2d_2_left: RayCast2D = %RayCast2D2Left
@onready var _attack_cooldown: Timer = %AttackCooldown
@onready var _attack_sfx: AudioStreamPlayer = %AttackSFX
@onready var _death_sfx: AudioStreamPlayer = %DeathSFX
@onready var _is_player_detected: bool = false
@onready var _is_player_in_damage_area: bool = false
@onready var _is_move_to_right: bool = true


@export var _rmelee_enemy_data: RMeleeEnemy

func _ready() -> void:
	if(_rmelee_enemy_data == null):
		printerr("Load rmelee_enemy data before adding to the tree: " + str(get_stack()))
	_init_data()
	add_to_group("enemies")
	velocity.y = 9.8
	_connect_signals()

func _physics_process(delta: float) -> void:
	if(_ray_cast_2d_2_left.is_colliding() == false):
		_is_move_to_right = true
	if(_ray_cast_2d_right.is_colliding() == false):
		_is_move_to_right = false
	if(_is_player_detected and !_is_player_in_damage_area and _me_animation_player.current_animation != "attack"):
		_move_to_player((get_tree().get_first_node_in_group("Player") as Player).global_position)
	if(!_is_player_detected and _me_animation_player.current_animation != "attack"):
		_auto_move()
	if(_is_player_in_damage_area):
		_attack()
	_handle_animations()
	move_and_slide()

func load_data(melee_enemy_resource: RMeleeEnemy) -> void:
	_rmelee_enemy_data = melee_enemy_resource

func _init_data() -> void:
	_attack_cooldown.wait_time = _rmelee_enemy_data.attack_cooldown

func _connect_signals() -> void:
	_sensor.body_entered.connect(_on_player_detected)
	_sensor.body_exited.connect(_on_player_undetected)
	_damage_zones.body_entered.connect(_on_player_in_damage_area)
	_damage_zones.body_exited.connect(_on_player_out_damage_area)
	_me_animation_player.animation_finished.connect(_on_animation_finished)
	_rmelee_enemy_data.dead.connect(_on_dead)

func _handle_animations() -> void:
	if(velocity.x > 0):
		_me_animation_player.play("move_right")
	elif(velocity.x < 0):
		_me_animation_player.play("move_left")

func _auto_move() -> void:
	if(_is_move_to_right):
		velocity.x = _rmelee_enemy_data.speed
	else:
		velocity.x = -_rmelee_enemy_data.speed

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
	if(_attack_cooldown.time_left == 0):
		_me_animation_player.play("attack")
		_attack_cooldown.start()
		_attack_sfx.play()

func _try_to_damage() -> void:
	for body: Node2D in _damage_zones.get_overlapping_bodies():
		if(body is Player):
			(body as Player).take_damage(_rmelee_enemy_data.damage)

func _on_player_detected(body: Node2D) -> void:
	if(body is Player):
		_is_player_detected = true

func _on_player_undetected(body: Node2D) -> void:
	if(body is Player):
		_is_player_detected = false

func _on_player_in_damage_area(body: Node2D) -> void:
	if(body is Player):
		_is_player_in_damage_area = true
		_attack()

func _on_player_out_damage_area(body: Node2D) -> void:
	if(body is Player):
		_is_player_in_damage_area = false

func _on_dead() -> void:
	(self as MeleeEnemy).process_mode = Node.PROCESS_MODE_DISABLED
	_death_sfx.play()
	_me_animation_player.play("death")

func _on_animation_finished(animation_name: String) -> void:
	if(animation_name == "death"):
		queue_free()
	elif(animation_name == "attack"):
		_me_animation_player.play("RESET")

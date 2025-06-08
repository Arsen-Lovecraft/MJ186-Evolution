class_name RangeEnemy
extends CharacterBody2D

const RANGE_ENEMY_PROJECTILE = preload("uid://bmhc4jqgn3c48")

@onready var _sensor: Area2D = %SensorArea2D
@onready var _re_animation_player: AnimationPlayer = %REAnimationPlayer
@onready var _ray_cast_2d_right: RayCast2D = %RayCast2DRight
@onready var _ray_cast_2d_2_left: RayCast2D = %RayCast2D2Left
@onready var _attack_cooldown: Timer = %AttackCooldown
@onready var _attack_sfx: AudioStreamPlayer = %AttackSFX
@onready var _death_sfx: AudioStreamPlayer = %DeathSFX
@onready var _crack: GPUParticles2D = %crack
@onready var _projectile_emit_position: Marker2D = %ProjectileEmitPosition
@onready var _is_player_in_damage_area: bool = false
@onready var _is_move_to_right: bool = true

@export var _rrange_enemy_data: RRangeEnemy

func _ready() -> void:
	if(_rrange_enemy_data == null):
		printerr("Load rrange_enemy data before adding to the tree: " + str(get_stack()))
	_init_data()
	add_to_group("enemies")
	_connect_signals()

func _physics_process(delta: float) -> void:
	if(!is_on_floor()):
			velocity.y += 9.8
	if(_ray_cast_2d_2_left.is_colliding() == false):
		_is_move_to_right = true
	if(_ray_cast_2d_right.is_colliding() == false):
		_is_move_to_right = false
	if(!_is_player_in_damage_area and _re_animation_player.current_animation != "attack"):
		_auto_move()
	if(_is_player_in_damage_area):
		_attack()
	_handle_animations()
	move_and_slide()

func load_data(range_enemy_resource: RRangeEnemy) -> void:
	_rrange_enemy_data = range_enemy_resource

func _init_data() -> void:
	_rrange_enemy_data.resource_local_to_scene = true
	_attack_cooldown.wait_time = _rrange_enemy_data.attack_cooldown

func _connect_signals() -> void:
	_sensor.body_entered.connect(_on_player_in_damage_area)
	_sensor.body_exited.connect(_on_player_out_damage_area)
	_re_animation_player.animation_finished.connect(_on_animation_finished)
	_rrange_enemy_data.dead.connect(_on_dead)

func _handle_animations() -> void:
	if(velocity.x > 0):
		_re_animation_player.play("move_right")
	elif(velocity.x < 0):
		_re_animation_player.play("move_left")

func _auto_move() -> void:
	if(_is_move_to_right):
		velocity.x = _rrange_enemy_data.speed
	else:
		velocity.x = -_rrange_enemy_data.speed

func _attack() -> void:
	velocity.x = 0
	if(_attack_cooldown.time_left == 0):
		_re_animation_player.play("attack")
		_attack_cooldown.start()
		_attack_sfx.play()

func _emit_projectile() -> void:
	var player_global_position: Vector2 = (get_tree().get_first_node_in_group("Player") as Player).global_position
	var projectile: RangeEnemyProjectile = RANGE_ENEMY_PROJECTILE.instantiate()
	projectile.damage = _rrange_enemy_data.damage
	projectile.global_position = _projectile_emit_position.global_position
	get_tree().current_scene.add_child(projectile)
	projectile.linear_velocity = _calculate_velocity(_projectile_emit_position.global_position,\
	player_global_position)

func _calculate_velocity(emitter_pos: Vector2, target_pos: Vector2, gravity: float = 980.0, arc_height: float = 50.0) -> Vector2:
	# Calculate displacement
	arc_height = randf_range(20, 100)
	var displacement: Vector2 = target_pos - emitter_pos
	var horizontal_distance: float = abs(displacement.x)
	# Calculate vertical velocity needed to reach arc height
	var vertical_speed: float = sqrt(2 * gravity * arc_height)
	# Calculate time components
	var time_to_peak: float = vertical_speed / gravity
	var time_to_fall: float = sqrt(2 * (arc_height + displacement.y) / gravity)
	var total_time: float = time_to_peak + time_to_fall
	# Calculate horizontal speed
	var horizontal_speed: float = horizontal_distance / total_time
	# Determine direction (left or right)
	var direction: float = sign(displacement.x)
	# Combine velocities
	var initial_velocity: Vector2 = Vector2(direction * horizontal_speed, -vertical_speed)
	# Apply velocity
	return initial_velocity


func _on_player_in_damage_area(body: Node2D) -> void:
	if(body is Player):
		_is_player_in_damage_area = true
		_attack()

func _on_player_out_damage_area(body: Node2D) -> void:
	if(body is Player):
		_is_player_in_damage_area = false

func _on_dead() -> void:
	_sensor.process_mode = Node.PROCESS_MODE_DISABLED
	self.set_physics_process(false)
	self.collision_layer = 0
	self.collision_mask = 0
	_death_sfx.play()
	_re_animation_player.play("death")

func _on_animation_finished(animation_name: String) -> void:
	if(animation_name == "death"):
		queue_free()
	elif(animation_name == "attack"):
		_re_animation_player.play("RESET")

func take_damage(damage: float) -> void:
	_crack.emitting = true
	_rrange_enemy_data.hp -= damage

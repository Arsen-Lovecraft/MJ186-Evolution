extends CharacterBody2D
class_name Player


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var punch_radius: Area2D = %punchRadius
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var punch_timer: Timer = %punchTimer
var playerDamage : float
var punching : bool = false

@export var _player_data: RplayerData

var flipChar : bool = true

# used to store face on movement for animation
var face :float = 1.0
var puncfreq : bool = true
var anim_locked: bool = false


func _ready() -> void:
	if(_player_data == null):
		printerr("Load player_data before adding to the tree: " + str(get_stack()))
	_connect_signals()
	add_to_group("Player")
	_init_data()

func _connect_signals()->void:
	punch_timer.connect("timeout",_punchCooldown)
	punch_radius.connect("body_entered", _on_body_entered)
	for enemies in get_tree().get_nodes_in_group("enemies"):
		pass

func _init_data() -> void:
	punch_timer.wait_time = _player_data.attack_cooldown
	playerDamage = _player_data.damage

func _on_body_entered(_body: Variant) -> void:
	if(_body is MeleeEnemy):
		(_body as MeleeEnemy).damage_enemy(playerDamage)
		print((_body as MeleeEnemy)._rmelee_enemy_data.hp)
	
func _physics_process(delta: float) -> void:

	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if face == 1.0:
		if not flipChar:
			player_sprite.flip_h = 0
			punch_radius.position.x *= -1
			player_collision.position.x *= -1
			flipChar = true
			

	elif face == -1.0:
		if flipChar:
			player_sprite.flip_h = 1
			punch_radius.position.x *= -1
			player_collision.position.x *= -1
			flipChar = false
			
	if not anim_locked:
		if direction:
			velocity.x = direction * SPEED
			face = direction
			if is_on_floor():
				play_animation("run")
			else:
				play_animation("jump")
		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				play_animation("idle")
			else:
				play_animation("jump")
	
	if Input.is_action_just_pressed("punch") and is_on_floor() and not anim_locked:
		anim_locked = true
		punching = true
		play_animation("punch1")
		await player_sprite.animation_finished
		punching = false
		anim_locked = false
	elif Input.is_action_just_pressed("punch") and not is_on_floor() and not anim_locked:
		anim_locked = true
		punching = true
		play_animation("punch2")
		await player_sprite.animation_finished
		punching = false
		anim_locked = false
	
	if punching:
		punch_radius.monitoring = 1
		punch_radius.visible = 1
	else:
		punch_radius.monitoring = 0
		punch_radius.visible = 0
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
#_punchCooldown Connected on connectsignals
func _punchCooldown() -> void:
	puncfreq = true

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)

func damage_player(damage: float) -> void:
	_player_data.hp -= damage/_player_data.playerLevel
	if _player_data.hp > 0:
		_player_data.mp += _player_data.playerMprate/(_player_data.playerLevel * _player_data.hp)
	anim_locked = true
	play_animation("damage")
	await player_sprite.animation_finished
	anim_locked = false

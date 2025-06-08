extends CharacterBody2D
class_name Player

signal gameOver

@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var punch_radius: Area2D = %punchRadius
@onready var player_collision: CollisionShape2D = %playerCollision
@onready var punch_timer: Timer = %punchTimer
@onready var regen_timer: Timer = %regenTimer
@onready var damage_not_taken: Timer = %damageNotTaken
const UPGRADES = preload("uid://bvivda3vnsbw5")

@export var _player_data : RplayerData = preload("uid://byrd0re6gadg6")

var flipChar : bool = true
var playerDamage : float
var punching : bool = false
# used to store face on movement for animation
var face :float = 1.0
var shootFreq : bool = true
var anim_locked: bool = false
var SPEED : float
var JUMP_VELOCITY : float
var regen_rate : float 
var mp_regen_rate : float 
var now_regen : bool = true
var damage_taken : bool = false


var puncfreq : bool = true


func _ready() -> void:
	if(_player_data == null):
		printerr("Load player_data before adding to the tree: " + str(get_stack()))
	_connect_signals()
	add_to_group("Player")
	_init_data()
	regen_timer.start()

func _connect_signals()->void:
	punch_timer.connect("timeout",_punchCooldown)
	regen_timer.connect("timeout",_regen)
	damage_not_taken.connect("timeout",_regenStart)
	punch_radius.connect("body_entered", _on_body_entered)
	_player_data.connect("dead", _on_dead)
	_player_data.connect("levelUp", _on_levelUp)
	for enemies in get_tree().get_nodes_in_group("enemies"):
		pass

func _init_data() -> void:
	punch_timer.wait_time = _player_data.attack_cooldown
	playerDamage = _player_data.damage
	SPEED = _player_data.SPEED
	JUMP_VELOCITY = _player_data.JUMP_VELOCITY
	regen_rate = _player_data.regen_rate
	mp_regen_rate = _player_data.mp_regen_rate / _player_data.hp

func _on_body_entered(_body: Variant) -> void:
	if(_body is MeleeEnemy):
		(_body as MeleeEnemy).damage_enemy(playerDamage)
	if(_body is RangeEnemy):
		(_body as RangeEnemy).damage_enemy(playerDamage)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += _player_data.gravity * delta

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
	
	if Input.is_action_just_pressed("punch") and is_on_floor() and not anim_locked and puncfreq:
		anim_locked = true
		punching = true
		play_animation("punch1")
		await player_sprite.animation_finished
		anim_locked = false
		puncfreq = false
		punching = false
		punch_timer.start()
		
	elif Input.is_action_just_pressed("punch") and not is_on_floor() and not anim_locked and puncfreq:
		anim_locked = true
		punching = true
		play_animation("punch2")
		await player_sprite.animation_finished
		anim_locked = false
		puncfreq = false
		punching = false
		punch_timer.start()
	
	if punching:
		punch_radius.monitoring = 1
		punch_radius.visible = 1
	else:
		punch_radius.monitoring = 0
		punch_radius.visible = 0
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

## _physics_process END
	
#_punchCooldown Connected on connectsignals
func _punchCooldown() -> void:
	puncfreq = true

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)

func damage_player(damage: float) -> void:
	_player_data.hp -= damage/_player_data.playerLevel
	damage_taken = true
	if _player_data.hp > 0:
		_player_data.mp += (_player_data.playerMprate * mp_regen_rate)/(_player_data.playerLevel * _player_data.hp)
		anim_locked = true
		play_animation("damage")
		await player_sprite.animation_finished
		anim_locked = false
		damage_not_taken.start()
		mp_regen_rate = (_player_data.mp_regen_rate * _player_data.playerMprate)/(_player_data.playerLevel * _player_data.hp)

func _on_dead()->void:
	anim_locked = true
	play_animation("death")
	await player_sprite.animation_finished
	anim_locked = false
	queue_free()
	#gameOver.emit()

func _on_levelUp() -> void:
	var upgradeui := UPGRADES.instantiate()
	add_child(upgradeui)
	get_tree().paused = true
	_player_data.playerLevel += 1
	_player_data.mp = 0

func _regen() -> void:
	if not damage_taken:
		_player_data.hp += regen_rate
		_player_data.mp += mp_regen_rate

func _regenStart() -> void:
	damage_taken = false

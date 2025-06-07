extends CharacterBody2D
class_name Player


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player_sprite: AnimatedSprite2D = %playerSprite
@onready var punch_radius: Area2D = %punchRadius
@onready var player_collision: CollisionShape2D = %playerCollision

var flipChar : bool = true

# used to store face on movement for animation
var face :float = 1.0
var shootFreq : bool = true
var anim_locked: bool = false


func _ready() -> void:
	$punchTimer.connect("timeout",_punchCooldown)
	punch_radius.connect("body_entered", _on_body_entered)
	for enemies in get_tree().get_nodes_in_group("enemies"):
		pass
	
func _on_body_entered(_body: Variant) -> void:
	print(_body)
	
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
		play_animation("punch1")
		await player_sprite.animation_finished
		anim_locked = false
	elif Input.is_action_just_pressed("punch") and not is_on_floor() and not anim_locked:
		anim_locked = true
		play_animation("punch2")
		await player_sprite.animation_finished
		anim_locked = false
	
	if anim_locked:
		punch_radius.monitoring = 1
		punch_radius.visible = 1
	else:
		punch_radius.monitoring = 0
		punch_radius.visible = 0
	
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	
	
#shootTimer Connected on ready
func _punchCooldown() -> void:
	shootFreq = true

func play_animation(anim_name: String) -> void:
	if player_sprite.animation != anim_name:
		player_sprite.play(anim_name)

func damage(value : float) -> void:
	print(value)

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player_sprite: AnimatedSprite2D = $playerSprite

# used to store face on movement for animation
var face :float = 1.0
var shootFreq : bool = true
@onready var cross_hair: Node2D = $CrossHair/crosshairMarker

signal shoot

func _ready() -> void:
	$shootTimer.connect("timeout",_shootFreq)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and shootFreq:
		var pos := cross_hair.global_position
		var shootDirec := (get_global_mouse_position() - self.global_position).normalized()
		$shootTimer.start()
		shootFreq = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		face = direction
		if face == 1.0:
			player_sprite.flip_h = 0
		else:
			player_sprite.flip_h = 1
			
		if is_on_floor():
			player_sprite.play("run")
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			player_sprite.play("idle")
			
	move_and_slide()
	
#shootTimer Connected on ready
func _shootFreq() -> void:
	shootFreq = true

extends Node2D

const playerBullet : PackedScene = preload("uid://cmr0d2sjs0vp8")
@onready var cross_hair : Marker2D = $Player/CrossHair/crosshairMarker
var direction:Vector2


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		player_shoot()
	direction = (get_global_mouse_position() - %Player.global_position).normalized()
	
		
func player_shoot() -> void:
	var bullet := playerBullet.instantiate()
	bullet.position = cross_hair.global_position
	bullet.direction = direction
	self.call_deferred("add_child", bullet)

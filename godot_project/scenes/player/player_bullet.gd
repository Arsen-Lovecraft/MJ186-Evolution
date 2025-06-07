extends Area2D

var direction: Vector2
var bulletSpeed := 200


func _ready() -> void:
	#self.connect("body_entered", _on_body_entered)
	#self.connect("area_entered", _on_body_entered)
	$BulletKill.connect("timeout", _on_BulletKill_timeout)
	$BulletKill.start()
	
func _process(delta: float) -> void:
	self.position += direction * delta * bulletSpeed
	#self.velocity += 1
	
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.has_method("hit") == true:
		body.hit()
	queue_free()

		
func _on_BulletKill_timeout() -> void:
	queue_free()

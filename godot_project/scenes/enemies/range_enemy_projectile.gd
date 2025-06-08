class_name RangeEnemyProjectile
extends RigidBody2D

var damage: float = 0

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	(self as RangeEnemyProjectile).body_shape_entered.connect(_on_body_shape__entered)

func _on_body_shape__entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if(body is Player):
		(get_tree().get_first_node_in_group("Player") as Player).take_damage(damage)
	queue_free()

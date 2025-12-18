class_name Enemy
extends RigidBody2D

signal died
const SPEED = 200.0


func _physics_process(_delta: float) -> void:
	if Global.player != null:
		look_at(Global.player.global_position)
		var dir := (Global.player.position - position).normalized()
		linear_velocity = dir * SPEED


func _on_body_entered(body: Node) -> void:
	if body is Bullet:
		_damage()
		body.queue_free()


func _damage() -> void:
	died.emit()
	queue_free()

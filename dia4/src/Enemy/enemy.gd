class_name Enemy
extends RigidBody2D

signal died
const SPEED = 200.0


func _physics_process(delta: float) -> void:
	if Global.player != null:
		look_at(Global.player.global_position)
		var dir := (Global.player.position - position).normalized()
		linear_velocity = dir * SPEED
	


func _on_body_entered(body: Node) -> void:
	if body is Bullet:
		queue_free()
		body.queue_free()
		died.emit()

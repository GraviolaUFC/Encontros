class_name Enemy
extends RigidBody2D

signal died
const SPEED = 200.0

const MAX_HP := 30.0
var current_hp := MAX_HP


func _physics_process(_delta: float) -> void:
	if Global.player != null:
		var dir := (Global.player.position - position).normalized()
		linear_velocity = dir * SPEED
		
		if linear_velocity != Vector2(0,0):
			$AnimatedSprite2D.play("walk_chicken")
		else:
			$AnimatedSprite2D.play("idle_chicken")
		
		var player_direction := (Global.player.global_position - global_position )
		if player_direction.x <= 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false


func _on_body_entered(body: Node) -> void:
	if body is Bullet:
		_damage()
		body.queue_free()


func _damage() -> void:
	$AnimatedSprite2D.modulate = Color.WHITE
	create_tween().tween_property($AnimatedSprite2D, "modulate", Color("#ff0000"), 0.5)
	current_hp -= 10.0
	if current_hp <= 0.0:
		died.emit()
		queue_free()

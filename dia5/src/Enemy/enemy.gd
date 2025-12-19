class_name Enemy
extends RigidBody2D

signal died
const SPEED = 200.0

const MAX_HP := 30.0
var current_hp := MAX_HP


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
	$Sprite2D.modulate = Color.WHITE
	create_tween().tween_property($Sprite2D, "modulate", Color("#ff0000"), 0.5)
	current_hp -= 10.0
	if current_hp <= 0.0:
		died.emit()
		queue_free()

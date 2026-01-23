class_name Enemy
extends RigidBody2D

signal died
const SPEED = 200.0

@onready var shader_material = $AnimatedSprite2D.material

const MAX_HP := 30.0
var current_hp := MAX_HP
var movement_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Segue o player se ele estiver vivo
	if Global.player != null and not Global.player.dead:
		movement_direction = (Global.player.position - position).normalized() # Direção até o jogador
		linear_velocity = movement_direction * SPEED
	else:
		linear_velocity = Vector2.ZERO
	
	# Seta a animação dependendo da velocidade atual
	if linear_velocity != Vector2(0,0):
		$AnimatedSprite2D.play("walk_chicken")
	else:
		$AnimatedSprite2D.play("idle_chicken")
	# Flipa o sprite dependendo da direção de movimento
	if movement_direction.x <= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body: Node) -> void:
	# Toma dano se colidir com uma bala
	if body is Bullet:
		_damage()
		body.queue_free() # apaga a bala


func _damage() -> void:
	# Animação de dano
	shader_material.set_shader_parameter("amount", 1.0)
	create_tween().tween_method(func(a):
		shader_material.set_shader_parameter("amount", a),
		1.0, 0.0, 0.25)
	
	# Efetiva o dano e checa se HP <= 0
	current_hp -= 10.0
	if current_hp <= 0.0:
		died.emit()
		queue_free()

class_name Player
extends CharacterBody2D

const MAX_HP := 50.0
var current_hp := MAX_HP

var dead := false

@onready var shader_material: ShaderMaterial = $AnimatedSprite2D.material

var move_speed := 300
var dash_speed := move_speed * 3

var bullet_scene := preload("res://src/Player/bullet.tscn")
var can_shoot := true
var invunerable := false

var dashing := false
var can_dash := true
var powerup_timer := 0.0
var dash_direction := Vector2(1 ,0)


func _ready() -> void:
	Global.player = self


func _process(delta: float) -> void:
	# Atualiza a posição da arma ao redor do player
	var gun_direction := (get_global_mouse_position() - global_position).normalized()
	$Gun.position = gun_direction * 40 # 40px na direção do mouse
	# Faz a arma estar rotacionada na direção do mouse
	$Gun.look_at(get_global_mouse_position())
	
	# Flipa o player e a arma se estiverem olhando pra esquerda
	var mouse_pos := get_local_mouse_position()
	if mouse_pos.x <= 0:
		$AnimatedSprite2D.flip_h = true
		# Flipa a arma na vertical pra ela não ficar de cabeça pra baixo
		$Gun.flip_v = true
	else:
		$AnimatedSprite2D.flip_h = false
		$Gun.flip_v = false
	
	# Lógica de dash
	if Input.is_action_just_pressed("dash") and can_dash:
		# Inicia o dash
		dashing = true
		%DashingTimer.start()
		
		# Inicia o delay do dash
		can_dash = false
		%CanDashTimer.start()
	
	powerup_timer -= delta
	powerup_timer = max(0, powerup_timer)


func _physics_process(delta: float) -> void:
	if dead: return
	
	# Direção de movimento de acordo com os inputs
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Atualiza a direção do dash se o player não estiver dando dash
	if not dashing and dir != Vector2(0,0):
		dash_direction = dir
	
	# Move o player
	velocity = dir * move_speed
	if dashing:
		velocity += dash_direction * dash_speed
	
	# Seta a animação de acordo com a velocidade atual
	if velocity == Vector2(0,0):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
	
	# Lógica de tiro
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_count = 1
		if powerup_timer > 0.0:
			bullet_count = 3
		for i in range(bullet_count):
			# Cria uma nova bala
			var bullet: RigidBody2D = bullet_scene.instantiate()
			get_parent().add_child(bullet)
			
			# Atualiza a posição inicial da bala pra ser a mesma da arma
			bullet.global_position = %Gun.global_position
			# Atira a bala na direção em que a arma está apontada
			var angle = (i - 1) * PI / 6
			if bullet_count == 1:
				angle = 0.0
			var bullet_dir := Vector2.from_angle(%Gun.rotation + angle)
			bullet.apply_impulse(bullet_dir * 500)
			
			# Inicia o cooldown de tiro
			can_shoot = false
			%ShootTimer.start()
	
	# Movimenta o jogador e lida com possível colisãos
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		var body := collision.get_collider()
		# Se o corpo colidido é um inimigo, toma dano
		if body is Enemy:
			_damage()
		elif body is PowerUp:
			powerup_timer = 10.0
			body.queue_free()


func _damage() -> void:
	if invunerable:
		return
	
	# Animação de dano
	shader_material.set_shader_parameter("amount", 1.0)
	create_tween().tween_method(func(a):
		shader_material.set_shader_parameter("amount", a),
		1.0, 0.0, 0.25)
	
	# Deixa o player invulnerável por um tempo
	invunerable = true
	%InvTimer.start()
	
	# Diminui o HP e mata o player se HP < 0.0
	current_hp -= 10.0
	if current_hp <= 0.0:
		hide()
		dead = true
		collision_layer = 0
		collision_mask = 0


#region Timeouts
func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_inv_timer_timeout() -> void:
	invunerable = false

func _on_can_dash_timer_timeout() -> void:
	can_dash = true

func _on_dashing_timer_timeout() -> void:
	dashing = false
#endregion

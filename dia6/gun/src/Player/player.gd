class_name Player
extends CharacterBody2D

const MAX_HP := 50.0
var current_hp := MAX_HP

var dead := false

var move_speed := 300
var dash_speed := move_speed * 3

var bullet_scene := preload("res://src/Player/bullet.tscn")
var can_shoot := true
var invunerable := false

var dashing := false
var can_dash := true
var dash_direction := Vector2(1 ,0)

func _ready() -> void:
	Global.player = self

func _process(_delta: float) -> void:
	var gun_direction := (get_global_mouse_position() - global_position).normalized()
	$Gun.position = gun_direction * 40
	$Gun.look_at(get_global_mouse_position())
	
	var mouse_pos := get_local_mouse_position()
	if mouse_pos.x <= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		%CanDashTimer.start()
		%DashingTimer.start()

func _physics_process(delta: float) -> void:
	if dead: return
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not dashing and dir != Vector2(0,0):
		dash_direction = dir
	
	velocity = dir * move_speed
	if dashing:
		velocity += dash_direction * dash_speed
	
	if velocity == Vector2(0,0):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
	
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet: RigidBody2D = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		
		bullet.position = %Gun.global_position
		var look_dir := Vector2.from_angle(%Gun.rotation)
		bullet.apply_impulse(look_dir * 500)
		
		can_shoot = false
		%ShootTimer.start()
	
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		var body := collision.get_collider()
		if body is Enemy:
			_damage()


func _damage() -> void:
	if invunerable:
		return
	
	$AnimatedSprite2D.modulate = Color.WHITE
	create_tween().tween_property($AnimatedSprite2D, "modulate", Color("#0088ff"), 0.5)
	
	invunerable = true
	%InvTimer.start()
	
	current_hp -= 10.0
	if current_hp <= 0.0:
		hide()
		dead = true
		collision_layer = 0
		collision_mask = 0

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_inv_timer_timeout() -> void:
	invunerable = false

func _on_can_dash_timer_timeout() -> void:
	can_dash = true

func _on_dashing_timer_timeout() -> void:
	dashing = false

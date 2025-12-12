class_name Player
extends CharacterBody2D

const MAX_HP := 50.0
var current_hp := MAX_HP

var move_speed := 300
var dash_speed := move_speed * 3
var bullet_scene := preload("res://src/Player/bullet.tscn")
var can_shoot := true
var invunerable := false

var dashing := false
var can_dash := true
var dash_direction := Vector2(0,0)

func _ready() -> void:
	Global.player = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		%CanDashTimer.start()
		%DashingTimer.start()

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not dashing and dir != Vector2(0,0):
		dash_direction = dir
	
	velocity = dir * move_speed
	if dashing:
		velocity += dash_direction * dash_speed
	
	if Input.is_action_pressed("shoot") and can_shoot:
		for i in range(-1, 2):
			var bullet: RigidBody2D = bullet_scene.instantiate()
			get_parent().add_child(bullet)
			
			bullet.position = %Gun.global_position
			var trinta = deg_to_rad(30)
			var look_dir := Vector2.from_angle(rotation + trinta * i)
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
	
	$Sprite2D.modulate = Color.WHITE
	create_tween().tween_property($Sprite2D, "modulate", Color("#0088ff"), 0.5)
	
	invunerable = true
	%InvTimer.start()
	
	current_hp -= 10.0
	if current_hp <= 0.0:
		queue_free()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_inv_timer_timeout() -> void:
	invunerable = false

func _on_can_dash_timer_timeout() -> void:
	can_dash = true

func _on_dashing_timer_timeout() -> void:
	dashing = false

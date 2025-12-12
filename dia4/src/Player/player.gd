class_name Player
extends CharacterBody2D

var move_speed := 300
var bullet_scene := preload("res://src/Player/bullet.tscn")
var can_shoot := true

func _ready() -> void:
	Global.player = self

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * move_speed
	
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
	
	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true

extends CharacterBody2D

var move_speed := 300
var bullet_scene := preload("res://bullet.tscn")


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * move_speed
	
	if Input.is_action_just_pressed("shoot"):
		var bullet: RigidBody2D = bullet_scene.instantiate()
		bullet.position = $Gun.global_position
		
		var bullet_dir = Vector2.from_angle(rotation)
		bullet.apply_impulse(bullet_dir * 1000)
		
		get_parent().add_child(bullet)
	
	move_and_slide()

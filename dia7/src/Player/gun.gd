extends Sprite2D

var can_shoot = true
var shoot_delay = 0.2
const BULLET_SCENE := preload("res://src/Player/bullet.tscn")

func shoot(bullet_count: int, guided: bool) -> void:
	if not can_shoot:
		return
	
	for i in range(bullet_count):
		# Cria uma nova bala
		var bullet: RigidBody2D = BULLET_SCENE.instantiate()
		bullet.guided = guided
		Global.arena.add_child(bullet)
		
		# Atualiza a posição inicial da bala pra ser a mesma da arma
		bullet.global_position = global_position
		
		# Atira a bala na direção em que a arma está apontada
		var initial_angle = -15 * (bullet_count - 1)
		var shoot_angle = deg_to_rad(initial_angle + i * 30)
		var bullet_dir := Vector2.from_angle(rotation + shoot_angle)
		bullet.apply_impulse(bullet_dir * 500)
		
		# Inicia o cooldown de tiro
		can_shoot = false
		get_tree().create_timer(shoot_delay).timeout.connect(func(): can_shoot = true)

class_name Bullet
extends RigidBody2D

func _process(_delta: float) -> void:
	var enemies = %EnemyDetector.get_overlapping_bodies()
	
	var closest_enemy : RigidBody2D
	var closest_distance := INF
	
	if len(enemies) > 0:
		for e: RigidBody2D in enemies:
			var distance = (position - e.position).length()
			if distance < closest_distance:
				closest_enemy = e
				closest_distance = distance
	
	if closest_enemy == null:
		return
	
	var dir = (closest_enemy.position - position).normalized()
	apply_force(dir * 5000.0)

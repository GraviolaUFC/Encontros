extends Node2D

var enemy_scene := preload("res://src/Enemy/enemy.tscn")
var contador_morte: int = 0


func _on_spawn_timer_timeout() -> void:
	%SpawnSampler.progress_ratio = randf()
	var enemy: Enemy = enemy_scene.instantiate()
	print(%SpawnSampler.global_position)
	enemy.position = %SpawnSampler.position + %Player.position - Vector2(576.0, 324.0)
	add_child(enemy)
	enemy.died.connect(_enemy_died)


func _enemy_died() -> void:
	contador_morte += 1

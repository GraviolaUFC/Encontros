extends Node2D

var enemy_scene := preload("res://src/Enemy/enemy.tscn")
var time_alive: float = 0.0


func _process(delta: float) -> void:
	time_alive += delta
	%Label.text = "%.2f" % [time_alive]


func _on_spawn_timer_timeout() -> void:
	%SpawnSampler.progress_ratio = randf()
	var enemy := enemy_scene.instantiate()
	enemy.position = %SpawnSampler.position
	add_child(enemy)

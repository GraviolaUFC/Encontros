extends Node2D

var enemy_scene := preload("res://src/Enemy/enemy.tscn")
var contador_morte: int = 0


func _ready() -> void:
	%MultiplayerSpawner.spawn_function = spawn


func spawn(enemy: Enemy) -> Enemy:
	return enemy


func _on_spawn_timer_timeout() -> void:
	%SpawnSampler.progress_ratio = randf()
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.position = %SpawnSampler.position + %Player.position - Vector2(576.0, 324.0)
	enemy.died.connect(_enemy_died)
	%MultiplayerSpawner.spawn(enemy)


func _enemy_died() -> void:
	contador_morte += 1


func _on_pause_button_toggled(toggled_on: bool) -> void:
	%PauseLabel.visible = toggled_on
	get_tree().paused = toggled_on

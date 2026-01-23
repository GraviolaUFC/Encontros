extends Node2D

var enemy_scene := preload("res://src/Enemy/enemy.tscn")
const POWERUP_SCENE := preload("res://src/power_up.tscn")
var contador_morte: int = 0


func rand_spawn_pos() -> Vector2:
	# Escolhe um ponto aleatório entre 0 e 100% do progresso da linha de spawn
	%SpawnSampler.progress_ratio = randf()
	# + offset do local do player (faz o spawn seguir a posição do player)
	# - offset do centro da tela (arrasta o ponto para fora da tela)
	return %SpawnSampler.position + %Player.position - Vector2(576.0, 324.0)


func _process(_delta: float) -> void:
	%LifeBar.value = %Player.current_hp / %Player.MAX_HP
	%PowerupBar.value = %Player.powerup_timer / 10.0


# Spawna inimigos conforme o timer SpawnTimer
func _on_spawn_timer_timeout() -> void:
	# Cria um novo inimigo em uma posição de spawn aleatória
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.position = rand_spawn_pos()
	# Adiciona ele como filho do nó de arena, pra meio que "conter"
	# os elementos do jogo em um único lugar (ajuda pro menu de pausa, etc.)
	%Arena.add_child(enemy)
	enemy.died.connect(_enemy_died)


func _enemy_died() -> void:
	contador_morte += 1
	%DeathCounter.text = str(contador_morte)

func _on_pause_button_toggled(pause: bool) -> void:
	# Desativa o processamento do nó de arena
	# (isso também desativa o processamento dos nós filhos! Ver documentação de "node > process_mode")
	if pause:
		%Arena.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		%Arena.process_mode = Node.PROCESS_MODE_INHERIT
	# Altera a visibilidade da tela de "jogo pausado"
	%PauseLabel.visible = pause
	


func _on_powerup_timer_timeout() -> void:
	var powerup = POWERUP_SCENE.instantiate()
	powerup.position = rand_spawn_pos()
	
	%Arena.add_child(powerup)

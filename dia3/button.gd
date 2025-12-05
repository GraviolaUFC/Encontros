extends Button

var numero_clicks := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5, 100, 5):
		print(i)


func botao_apertado() -> void:
	numero_clicks += 1
	text = str(numero_clicks)
	if numero_clicks % 2 == 0:
		modulate = Color.WHITE
	else:
		modulate = Color.RED

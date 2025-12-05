extends Node2D

# Arrays são listas de itens
var array1: Array = [1, 2, 3]
# Eles podem conter itens de tipos diferentes
var array2: Array = [1, "Graviola", Vector2(0, 1)]
# A não ser que você especifique o tipo do array!
var array_int:    Array[int] = [1, 2, 3]
var array_float:  Array[float] = [1.0, 0.24, 1, -3]
var array_string: Array[String] = ["Olá,", "Mundo!"]
# Eles podem ser acessados da seguinte maneira, com índices começando em 0:
var elemento_1 = array1[0]
var elemento_2 = array1[1]
var elemento_3 = array1[2]

# Dicionários são como "tabelas" chave - elemento
var dict1: Dictionary = {"idade": 21, "nome": "Júlia", 0: "chave [0]"}
# Eles podem usar tanto : quanto = (Como dicionários em python e em lua, respectivamente.)

# Você também pode especificar o tipo das chaves e dos elementos do dicionário
var dict_idades: Dictionary[String, int] = {"Júlia": 21, "Gerson": 42, "Enzo": 12}
# Eles são acessados que nem arrays.
var idade_ju = dict1["idade"]
var chave_0_ju = dict1[0]
var idade_enzo = dict_idades["Enzo"]

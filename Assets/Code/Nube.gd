extends Node2D

onready var SPRITE = get_node("Sprite")
export(float,1000)var speed: float = 3
export(float,10)var frequency: float = 5
export(float, 10)var amplitude: float = 150
var time = 0

#Agregar init() para que las nubes tengan un toque más de personalidad
# Idea: El spawn de nubes se puede usar como sistema de particulas, pero godot ya tiene asi que no se

func _ready():
	randomize()
	SPRITE.frame = round(rand_range(0,3))
	pass

func _process(delta):
	if(time > 2.5):
		_destruir()
	time += delta
	position.y += delta * speed
	position.x += cos(time*frequency) * amplitude
	
func _destruir():
	queue_free()

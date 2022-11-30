extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.set_wait_time(3)
	timer.start()
	#Aca haces que cuando termina de contar llame a la funcion que lo DESTRUYE
	timer.connect("timeout", self, "_destruir")

#BALA SUBE 13 VELOCIDAD RAPIDO SII
func _process(delta):
	position.y -= 13 
	
func _destruir():
	queue_free()

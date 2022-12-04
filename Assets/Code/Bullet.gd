extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()
const SPEED = 16


func _ready():
	add_child(timer)
	timer.set_wait_time(3)
	timer.start()
	#Aca haces que cuando termina de contar llame a la funcion que lo DESTRUYE
	timer.connect("timeout", self, "_destruir")

#BALA SUBE VELOCIDAD RAPIDO SII
func _process(delta):
	position.y -= SPEED
	
func _destruir():
	queue_free()

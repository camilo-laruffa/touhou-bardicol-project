extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()
export(float) var SPEED_Y: float = -16
export(float) var SPEED_X: float = 0



func _ready():
	set_physics_process(true)
	add_child(timer)
	timer.set_wait_time(10)
	timer.start()
	#Aca haces que cuando termina de contar llame a la funcion que lo DESTRUYE
	timer.connect("timeout", self, "_destruir")

#BALA SUBE VELOCIDAD RAPIDO SII
func _physics_process(delta):
	position.y += SPEED_Y
	position.x += SPEED_X
	
func _destruir():
	queue_free()


func _on_Hitbox_area_entered(area):
		#Hace que las balas sepan si las disparo un enemgio o el jugador y depende de ello si le hace daño
		#al jugador o al enemigo
	pass

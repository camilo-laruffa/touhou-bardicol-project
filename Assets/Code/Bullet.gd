extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()
export(float) var SPEED_Y: float = -16
export(float) var SPEED_X: float = 0
onready var SPRITE = get_node("Sprite")
var damage = 3
var Modulate
var Self_modulate
var Frame = 5
var Player_bullet = true

# Usamos un iniciador para setear los valores que queremos de la bala
func init(var player_bullet: bool, var type: int, var speed_x: float, var speed_y: float):
	if(!player_bullet):
		Modulate = Color(1,1,1)
		Self_modulate = Color(1,1,1)
	Frame = type
	SPEED_X = speed_x
	SPEED_Y = speed_y
	Player_bullet = player_bullet
	pass

func _ready():
	set_physics_process(true)
	
	if(!Player_bullet):
		SPRITE.self_modulate = Self_modulate
		SPRITE.modulate = Modulate
	SPRITE.frame = Frame
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
		#Hace que las balas sepan si las disparo un enemigo o el jugador y depende de ello si le hace daño
		#al jugador o al enemigo
	pass

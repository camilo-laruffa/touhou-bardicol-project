extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()
onready var SPRITE = get_node("Sprite")
var damage = 3
var Modulate
var Self_modulate
var Frame = 5
var Player_bullet = true
var velocity = Vector2(0,1)
var speed = 100

# Usamos un iniciador para setear los valores que queremos de la bala
func init(var player_bullet: bool, var type: int, var direction: Vector2, var b_speed: float):
	if(!player_bullet):
		Modulate = Color(1,1,1)
		Self_modulate = Color(1,1,1)
	Frame = type
	velocity = direction
	Player_bullet = player_bullet
	speed = b_speed
	pass

func _ready():
	set_physics_process(true)
	if(!Player_bullet):
		SPRITE.self_modulate = Self_modulate
		SPRITE.modulate = Modulate
		#Esto solo lo gira "bien" de un lado
		#rotation = position.angle_to_point(get_parent().get_node("Player").position) + 1.5
	else: 
		get_node("AudioStreamPlayer").volume_db = -60
	SPRITE.frame = Frame
	add_child(timer)
	timer.set_wait_time(3)
	timer.start()
	#Aca haces que cuando termina de contar llame a la funcion que lo DESTRUYE
	timer.connect("timeout", self, "_destruir")

#BALA SUBE VELOCIDAD RAPIDO SII
func _physics_process(delta):
	move_and_slide(velocity * speed)
	
func _destruir():
	queue_free()


func _on_Hitbox_area_entered(area):
		#Hace que las balas sepan si las disparo un enemigo o el jugador y depende de ello si le hace daño
		#al jugador o al enemigo
	pass

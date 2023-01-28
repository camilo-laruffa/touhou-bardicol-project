extends KinematicBody2D

#Usamos un timer para que cuando pasan los segundos se destruya la bala 
var timer = Timer.new()
onready var SPRITE = get_node("Sprite")
var damage = 10
var Modulate
var Self_modulate
var Frame = 5
var Player_bullet = true
var Direction = Vector2(0,1)
var speed = 100
var Bullet_duration

# Usamos un iniciador para setear los valores que queremos de la bala
func init(var player_bullet: bool, var type: int, var direction: Vector2, var b_speed: float, var bullet_duration):
	if(!player_bullet):
		Modulate = Color(1,1,1)
		Self_modulate = Color(1,1,1)
	Frame = type
	Direction = direction
	Player_bullet = player_bullet
	speed = b_speed
	Bullet_duration = bullet_duration
	pass

func _ready():
	if(!Player_bullet):
		SPRITE.self_modulate = Self_modulate
		SPRITE.modulate = Modulate
		look_at(get_tree().get_nodes_in_group("player")[0].global_position)
		rotation -= PI/2
	else: 
		damage = get_tree().get_nodes_in_group("player")[0].POWER
		speed = 80
		scale = Vector2(1.3, 1.3)
	SPRITE.frame = Frame
	add_child(timer)
	timer.set_wait_time(Bullet_duration)
	timer.start()
	#Aca haces que cuando termina de contar llame a la funcion que lo DESTRUYE
	timer.connect("timeout", self, "_destruir")

#BALA SUBE VELOCIDAD RAPIDO SII
func _process(delta):
	move_and_slide(Direction * speed)
	_chequear_despawn()
	
func _destruir():
	queue_free()
	
func _chequear_despawn():	
	if position.x > 900 || position.x < -100:
		queue_free()
	if position.y > 720 || position.y < 0:
		queue_free()

func _on_Hitbox_area_entered(area):
	if Player_bullet && area.name.to_upper() == "HURTBOX_ENEMY" :
		queue_free()		
	pass

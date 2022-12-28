extends KinematicBody2D

onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn")
onready var sprite = get_node("Sprite")
onready var hitbox = get_node("Sprite/Hitbox")
export(float) var SPEED: float = 300
var velocity = Vector2()
var speed
const CD = 0.1
var can_Shoot = true
var Visible = false
var timer = Timer.new() #Este timer es el del disparo

func _ready():
	set_physics_process(true)
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(CD) #Cada CD seg puede disparar
	timer.connect("timeout", self, "_can_Shoot")	
	
func _physics_process(delta):
	_manage_input(delta)
	velocity = move_and_slide(velocity)
	

#Controla el input
func _manage_input(delta):
	velocity = Vector2()
	speed = SPEED/2.5 if (Input.is_action_pressed("shift")) else SPEED #Esto no es lo más optimo pero queria probarlo jasja
	Visible = true if (Input.is_action_pressed("shift")) else false
	get_node("Sprite/Hitbox").set_visible(Visible)	
	
	if Input.is_action_pressed("shoot" ) && can_Shoot: 
		_shoot()
		timer.start()	
	#Movimiento	CANNOT GO OUT OF BOUNDS
	if Input.is_action_pressed("left") && position.x > 70: velocity.x -= 1
	if Input.is_action_pressed("right") && position.x < 790: velocity.x += 1
	if Input.is_action_pressed("up") && position.y > 10: velocity.y -= 1
	if Input.is_action_pressed("down") && position.y < 680: velocity.y += 1
	velocity = velocity.normalized() * speed 
	
#Crea una instancia de bala, la mete a la escena y despues le setea la posicion inicial arriba del jugador
func _shoot():
	var bullet = BULLET.instance()
	#Los valores de las balas del jugador no son customizables sin cambiar el codigo
	bullet.init(true,3,Vector2(0,-16),100,1)
	get_parent().add_child(bullet)
	bullet.get_node("Hitbox").player_bullet = true
	bullet.global_position = Vector2(get_node("Sprite").global_position.x, get_node("Sprite").global_position.y - 60)
	bullet.damage = 3
	can_Shoot = false

func _can_Shoot():
	can_Shoot = true #Podes disparar cuando termina el timer


func _on_Hurtbox_area_entered(area):
	
	pass # Replace with function body.

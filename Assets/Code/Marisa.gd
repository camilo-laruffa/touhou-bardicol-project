extends Node

onready var BULLET = preload("res://Assets/Scenes/Bullet.tscn")
onready var sprite = get_node("Sprite")
const SPEED = 6
var speed
var can_Shoot = true
var timer = Timer.new() #Este timer es el del disparo

func _ready():
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "_can_Shoot")
	
func _process(delta):
	_manage_input()

#Controla el input
func _manage_input():
	speed = SPEED
	get_node("Sprite").get_child(0).set_visible(false)	
	if Input.is_action_pressed("shift"):
		speed = SPEED * 0.5
		get_node("Sprite").get_child(0).set_visible(true)	
	if Input.is_action_pressed("shoot" ) && can_Shoot: 
		_shoot()
		timer.start()
	
	
	#Movimiento	
	if Input.is_action_pressed("left"): sprite.global_position.x -= speed
	if Input.is_action_pressed("right"): sprite.global_position.x += speed
	if Input.is_action_pressed("up"): sprite.global_position.y -= speed
	if Input.is_action_pressed("down"): sprite.global_position.y += speed
	
#Crea una instancia de bala, la mete a la escena y despues le setea la posicion inicial arriba del jugador
func _shoot():
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.global_position = Vector2(get_node("Sprite").global_position.x, get_node("Sprite").global_position.y - 60)
	can_Shoot = false

func _can_Shoot():
	can_Shoot = true #Puedes disparar cuando termina el timer

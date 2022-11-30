extends Node

onready var BULLET = preload("res://Assets/Scenes/Bullet.tscn")
onready var sprite = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	_manage_input()
	pass

#Controla el input
func _manage_input():
	if Input.is_action_pressed("shoot"):
		_shoot()
	if Input.is_action_pressed("left"):
		sprite.global_position.x -= 5
	if Input.is_action_pressed("right"):
		sprite.global_position.x += 5
	if Input.is_action_pressed("up"):
		sprite.global_position.y -= 5
	if Input.is_action_pressed("down"):
		sprite.global_position.y += 5
	
#Crea una instancia de bala, la mete a la escena y despues le setea la posicion inicial arriba del jugador
func _shoot():
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.global_position = Vector2(get_node("Sprite").global_position.x, get_node("Sprite").global_position.y - 40)
	pass



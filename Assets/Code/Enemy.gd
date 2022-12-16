extends Node2D

export(float) var HP: float = 100 
export(float) var CD: float = 1 
export(float,1000) var SPEED: float = 10
export(int) var LIVES: int = 3 
export(int) var FRAME: int = 13
export(float, 100) var offset: float = 5
onready var SPRITE_SHEET = preload("res://Assets/Sprites/marisa_spritesheet.png")
onready var sprite = get_node("Sprite")
onready var BULLET = preload("res://Assets/Scenes/Bullet.tscn")
onready var BONUS = preload("res://Assets/Scenes/Bonus.tscn")
var bullet 
var lives
var hp
var time = 0
export(float,100) var amplitude: float = 3
var timer = Timer.new()

#POR AHORA SOLO TIENEN LA OPCION DE HACER BALAS EN CIRCULO, PERO PODEMOS PONER OPCIONES
#LASERS, MUCHAS EN UNA DIRECCION, QUE EXPLOTEN, QUE SIGAN AL JUGADOR, LAS POSIBILIDADES SON ILIMITADAS
#EL MUNDO ES NUESTRO CANVAS
#PODEMOS HACER DISTINTAS ESCENAS CON CONJUNTOS DE ENEMIGOS Y ATAQUES DIFERENTES
#SOLO TENEMOS QUE PERFECCIONAR EL CREADOR PARA PODER HACER PATRONES A NUESTRO GUSTO

func _ready():
	_circle_bullet()
	randomize()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(CD) #Cada CD seg puede disparar
	timer.connect("timeout", self, "_can_Shoot")
	set_physics_process(true)
	#Aca le decimos que nos de un sprite aleatorio(es solo por ahora que debugeamos)
	sprite.texture = SPRITE_SHEET
	sprite.frame = round(rand_range(13,15))
	hp = HP
	lives = LIVES
	pass
	
func _physics_process(delta):
	position.y += SPEED*delta
	if(timer.is_stopped()): 
		timer.start()
		_circle_bullet()
	pass

func _on_HurtBox_area_entered(hitbox):
	if(hitbox.player_bullet):
		_recieve_damage(hitbox.damage)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lives -= 1
		hp = HP
	if (lives <= 0): 
		var bonus = BONUS.instance()
		bonus.init("POWER",1)
		bonus.position = position
		get_parent().add_child(bonus)
		queue_free() 
	
func _circle_bullet():
	#Aca creo una bala cada x grados para armar un circulo
	for i in range(0,380,20):
		var bullet = BULLET.instance()
		bullet.init(false,4,5*cos(i),5*sin(i))
		add_child(bullet)
		bullet.global_position = Vector2(position.x + cos(i)*amplitude, position.y + sin(i)*amplitude)
	pass

extends KinematicBody2D

# Export hace que las variables se puedan cambiar en el Inspector, 
# eso nos deja customizar cada prefab por separado
export(float) var HP: float = 100 
export(float,20) var SHOOT_CD: float = 1 
export(float,2) var BULLET_CD: float = 0.3 
export(float,1000) var SPEED: float = 10
export(float,1000) var BULLET_SPEED: float = 100
export(float,1000) var TIME_ALIVE: float = 100
export(int) var LIVES: int = 3 
export(int) var ANGLE: int = 15 
export(int) var ENEMY_FRAME: int = 13
export(int) var BULLET_FRAME: int = 8
export(String) var SHOOT_TYPE: String = "Circle Down"
export(float,1000) var RADIO: float = 3
export(int,-1,1) var direccion_horizontal: int = 1
export(int,-1,1) var direccion_vertical: int = 0
onready var SPRITE_SHEET = preload("res://Assets/Sprites/marisa_spritesheet.png")
onready var sprite = get_node("Sprite")
onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn")
onready var BONUS = preload("res://Assets/Scenes/Prefabs/Bonus.tscn")
var bullet 
var lives
var hp
var shoot_timer = Timer.new()
var bullet_timer = Timer.new()
var death_timer = Timer.new()
var player_position
var velocity
var can_shoot = false


func _ready():
	randomize()
	add_child(shoot_timer)
	add_child(bullet_timer)
	add_child(death_timer)
	shoot_timer.set_one_shot(true)
	bullet_timer.set_one_shot(true)
	death_timer.set_one_shot(true)
	death_timer.set_wait_time(TIME_ALIVE) 
	shoot_timer.set_wait_time(SHOOT_CD) #Cada CD seg puede disparar
	bullet_timer.set_wait_time(BULLET_CD) #Cada CD seg puede salir una bala (osea bullet_cd < shoot_cd)
	set_physics_process(true)
	sprite.frame = ENEMY_FRAME
	hp = HP
	lives = LIVES
	death_timer.start()
	
func _physics_process(delta):
	if death_timer.is_stopped(): queue_free() # TE MORIS HIJO DE PUTA AJAJAJAJAAJAAJ
	_movement()
	if SHOOT_CD != 0 :
		if shoot_timer.is_stopped() :
			can_shoot = !can_shoot
			shoot_timer.start()
	else:
		can_shoot = true
	if can_shoot:
		if bullet_timer.is_stopped() :
			_shoot(SHOOT_TYPE)
			bullet_timer.start()

func _movement():
	move_and_slide(Vector2(direccion_horizontal,direccion_vertical).normalized() * SPEED)
		
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

func _shoot(var type: String):
	type = type.to_upper()
	match type:
		"CIRCLE EXPLOSION":
			_circle_bullet(1)
		"CIRCLE AIMBOT":
			_circle_bullet(2)
		"CIRCLE DOWN":
			_circle_bullet(3)
		"AUTOAIM":
			_autoaim()
		_:
			print("Invalid shooting type: ", type)
			

func _autoaim():
	#Enviamos una bala hacia la posicion del jugador
	var bullet = BULLET.instance()
	player_position = get_node("../Player").position
	var direction = position.direction_to(player_position)
	
	bullet.init(false,BULLET_FRAME,direction,BULLET_SPEED)
	get_parent().add_child(bullet)
	bullet.position = position
	pass
	
func _circle_bullet(var type):
	#Aca creo una bala cada x grados para armar un circulo
	#Si le agregas un timer a la bala cada x tiempo + tiempototal podes hacer el efecto de disparo
	#donde salen de a 1 las balas
	var direction = Vector2(0,1)
	for i in range(0,360 + ANGLE,ANGLE):
		var bullet = BULLET.instance()
		if (type == 1): 
			direction = Vector2(cos(i),sin(i))
		if (type == 2): 
			player_position = get_parent().get_node("Player").position
			direction =  position.direction_to(player_position)
		bullet.init(false,BULLET_FRAME,direction,BULLET_SPEED)			
		get_parent().add_child(bullet)
		bullet.position = Vector2(position.x + cos(i)*RADIO,position.y + sin(i)*RADIO)
		bullet.get_node("AudioStreamPlayer").volume_db = -62
	pass

extends KinematicBody2D

# Export hace que las variables se puedan cambiar en el Inspector, 
# eso nos deja customizar cada prefab por separado
export(float) var HP: float = 100 #La vida del enemigo
export(float,20) var SHOOT_CD: float = 1 # Cada cuanto dispara(espera x tiempo, dispara x tiempo, espera x tiempo)
export(float,20) var BULLET_DURATION: float = 1 # Cuanto dura una bala antes de desaparecer
export(float,20) var BULLET_CD: float = 0.3 # Una vez puede disparar, cada cuanto puede salir 1 disparo
export(float,1000) var SPEED: float = 10 # Velocidad del enemigo
export(float,1000) var BULLET_SPEED: float = 100 # Velocidad de la bala(constante)
export(float,1000) var TIME_ALIVE: float = 10 # Cuanto tiempo vive el enemigo antes de despawnear
export(int) var LIVES: int = 3 # Cuantas vidas tiene el enemigo
export(int) var ANGLE: int = 15 # Cada cuantos grados aparece una bala en el disparo circular
export(int) var ENEMY_FRAME: int = 13 # Que frame del spritesheet usa para el sprite del enemigo
export(int) var BULLET_FRAME: int = 8 # Que frame del spritesheet usa para el sprite de la bala
export(String) var SHOOT_TYPE: String = "Circle Down" # Tipo de disparo (en la funcion te podes fijar cuales son)
export(float,1000) var RADIO: float = 3 # El radio en el que aparecen las balas en el disparo circular
export(int,-1,1) var direccion_horizontal: int = 1 # Direccion horizontal del movimiento(-1 izq ,0, 1 derecha)
export(int,-1,1) var direccion_vertical: int = 0 # Direccion vertical del movimiento(-1 arriba ,0, 1 abajo)
onready var SPRITE_SHEET = preload("res://Assets/Sprites/marisa_spritesheet.png") # Precarga la spritesheet
onready var sprite = get_node("Sprite") # Obtiene el sprite para editarlo
onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn") # Precarga la bala
onready var BONUS = preload("res://Assets/Scenes/Prefabs/Bonus.tscn") # Precarga el bonus
# Estas variables son para no alterar los valores iniciales de las mismas
var bullet 
var lives
var hp
var shoot_timer = Timer.new()
var bullet_timer = Timer.new()
var death_timer = Timer.new()
var player_position
var velocity
var can_shoot = true
var bullets


func _ready():
	randomize()
	add_child(shoot_timer) #Añadimos un timer
	add_child(bullet_timer)
	add_child(death_timer)
	shoot_timer.set_one_shot(true) #Le decimos que empiece de una
	bullet_timer.set_one_shot(true)
	death_timer.set_one_shot(true)
	death_timer.set_wait_time(TIME_ALIVE) #Le decimos cuanto dura
	shoot_timer.set_wait_time(SHOOT_CD) 
	bullet_timer.set_wait_time(BULLET_CD) 
	set_physics_process(true)
	sprite.frame = ENEMY_FRAME
	hp = HP
	lives = LIVES
	death_timer.start()
	self.add_to_group("enemies")
	
func _physics_process(delta):
	if death_timer.is_stopped(): queue_free() # Cuando se acaba el tiempo, muere
	_movement()
	if SHOOT_CD != 0 :
		if shoot_timer.is_stopped() :
			can_shoot = !can_shoot
			shoot_timer.start()
	else:
		can_shoot = true
	if can_shoot:
		if bullet_timer.is_stopped() : # Si puede disparar y paso x tiempo desde la ultima bala, puede disparar otra
			_shoot(SHOOT_TYPE)
			bullet_timer.start()

func _movement():
	move_and_slide(Vector2(direccion_horizontal,direccion_vertical).normalized() * SPEED) #Moverse !!
		
func _on_HurtBox_area_entered(hitbox):
	if hitbox.name == "Hitbox_Bullet" && hitbox.player_bullet :
		_recieve_damage(hitbox.damage)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lives -= 1
		hp = HP
	if (lives <= 0): 
		var bonus = BONUS.instance()
		bonus.init("POWER",1,false)
		bonus.position = position
		get_parent().call_deferred("add_child", bonus)
		queue_free() 

func _shoot(var type: String):
	type = type.to_upper() # Aca hace que todo sea mayusculas para que no haya problem	
	print("Instancing Shoot..")
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
			print("Invalid shooting type: ", type) # Si escribiste mal el tipo de disparo te dice que sos pelotudo
			

func _autoaim():
	#Enviamos una bala hacia la posicion del jugador
	var bullet = BULLET.instance()
	player_position = Vector2(0,0)
	if(is_instance_valid(get_node("../../Player"))): # Aveces se bugea, asi que primero nos fijamos que exista el jugador y dsp obtenemos donde esta
		player_position = get_node("../../Player").position
	var direction = position.direction_to(player_position)
	
	bullet.init(false,BULLET_FRAME,direction,BULLET_SPEED,BULLET_DURATION) # Iniciamos la bala con todo lo necesario
	bullet.position = position
	get_parent().call_deferred("add_child", bullet)
	bullet.add_to_group("bullets")
	pass
	
func _circle_bullet(var type):
	#Aca creo una bala cada x grados para armar un circulo
	player_position = Vector2(0,0)
	var direction = Vector2(0,1)
	var j = 0
	for i in range(0, 360, ANGLE):
		var bullet = BULLET.instance()
		bullet.position = Vector2(position.x + cos(deg2rad(i))*RADIO,position.y + sin(deg2rad(i))*RADIO)
		
		if (type == 1): 
			direction = Vector2(cos(deg2rad(i)),sin(deg2rad(i)))
		if type == 2 && is_instance_valid(get_node("../../Player")): 
			player_position = get_node("../../Player").position
			direction =  bullet.position.direction_to(player_position)			
		
		bullet.init(false,BULLET_FRAME,direction,BULLET_SPEED,BULLET_DURATION)
		get_parent().call_deferred("add_child", bullet)
		bullet.get_node("AudioStreamPlayer").volume_db = -62
		bullet.add_to_group("bullets")
	pass


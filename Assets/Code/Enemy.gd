extends KinematicBody2D

# Export hace que las variables se puedan cambiar en el Inspector, 
# eso nos deja customizar cada prefab por separado
export(float) var HP: float = 1 #La vida del enemigo
export(float,20) var WAIT_CD: float = 2 # Cuanto espera para empezar a disparar
export(float,20) var BULLET_DURATION: float = 1 # Cuanto dura una bala antes de desaparecer
export(float,20) var BULLET_CD: float = 0.3 # Una vez puede disparar, cada cuanto puede salir 1 disparo
export(float,1000) var SPEED: float = 10 # Velocidad del enemigo
export(float,1000) var BULLET_SPEED: float = 100 # Velocidad de la bala(constante)
export(float,1000) var TIME_ALIVE: float = 10 # Cuanto tiempo vive el enemigo antes de despawnear
export(int) var LIVES: int = 3 # Cuantas vidas tiene el enemigo
export(int) var ANGLE: int = 15 # Cada cuantos grados aparece una bala en el disparo circular
export(int) var ENEMY_FRAME: int = 13 # Que frame del spritesheet usa para el sprite del enemigo
export(int) var SHOOT_CANT: int = 2 # Cuantas veces puede disparar
export(int) var BULLET_FRAME: int = 8 # Que frame del spritesheet usa para el sprite de la bala
export(String,"AUTOAIM","CIRCLE DOWN","CIRCLE AIMBOT","CIRCLE EXPLOSION") var SHOOT_TYPE: String = "AUTOAIM" # Tipo de disparo (en la funcion te podes fijar cuales son)
export(String,"POWER","POINT","BOMB","EXTEND") var DROP_TYPE: String = "POWER"
export(float,1000) var RADIO: float = 100 # El radio en el que aparecen las balas en el disparo circular
export(int,-1,1) var direccion_horizontal: int = 1 # Direccion horizontal del movimiento(-1 izq ,0, 1 derecha)
export(int,-1,1) var direccion_vertical: int = 0 # Direccion vertical del movimiento(-1 arriba ,0, 1 abajo)
onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn") # Precarga la bala
onready var BONUS = preload("res://Assets/Scenes/Prefabs/Bonus.tscn") # Precarga el bonus
# Estas variables son para no alterar los valores iniciales de las mismas
var bullet 
var lives
var hp
var player_position 
var can_shoot = false
var bullets

func _ready():
	set_physics_process(true)
	hp = HP
	lives = LIVES
	$Death_Timer.set_wait_time(TIME_ALIVE) 
	$Bullet_Timer.set_wait_time(BULLET_CD) 
	$Wait_Timer.set_wait_time(WAIT_CD)
	$Wait_Timer.start()
	$Death_Timer.start()
	$Sprite.frame = ENEMY_FRAME
	self.add_to_group("enemies")
	
func _physics_process(delta):
	_movement()
	if (SHOOT_CANT <= 0) : can_shoot = false
	if position.y > 720 : queue_free()
	
func _on_Wait_Timer_timeout():
	$Bullet_Timer.start()
	can_shoot = true

func _on_Bullet_Timer_timeout():
	$Bullet_Timer.start()	
	if !can_shoot : return	
	_shoot(SHOOT_TYPE)
	
func _on_Death_Timer_timeout():
	queue_free()

func _movement():
	move_and_slide(Vector2(direccion_horizontal,direccion_vertical).normalized() * SPEED) #Moverse !!
		
func _on_HurtBox_area_entered(hitbox):
	if hitbox.name == "Hitbox_Bullet" && hitbox.get_parent().Player_bullet :
		_recieve_damage(get_tree().get_nodes_in_group("player")[0].POWER)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lives -= 1
		hp = HP
	if (lives <= 0): 
		_die()
func _die():	
	# Agrega que ponga varios bonus en partes random pero cercanas a donde muere el bicho, asi se ve bonito
	var bonus = BONUS.instance()
	bonus.init(DROP_TYPE,1,false)
	if get_tree().get_nodes_in_group("player")[0].POWER >= 3.95 && DROP_TYPE == "POWER" :
		bonus.init("POINT",1,false)
	bonus.position = position
	get_parent().call_deferred("add_child", bonus)
	queue_free() 

func _shoot(var type: String):
	SHOOT_CANT -= 1
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
			print("Invalid shooting type: ", type) # Si escribiste mal el tipo de disparo te dice que sos pelotudo
			

func _autoaim():
	#Enviamos una bala hacia la posicion del jugador
	var bullet = BULLET.instance()
	player_position = Vector2(0,0)
	if(is_instance_valid(get_tree().get_nodes_in_group("player")[0])): # Aveces se bugea, asi que primero nos fijamos que exista el jugador y dsp obtenemos donde esta
		player_position = get_tree().get_nodes_in_group("player")[0].position
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
		if type == 2 && is_instance_valid(get_tree().get_nodes_in_group("player")[0]): 
			player_position = get_tree().get_nodes_in_group("player")[0].position
			direction =  bullet.position.direction_to(player_position)			
		
		bullet.init(false,BULLET_FRAME,direction,BULLET_SPEED,BULLET_DURATION)
		get_parent().call_deferred("add_child", bullet)
		bullet.get_node("AudioStreamPlayer").volume_db = -62
		bullet.add_to_group("bullets")

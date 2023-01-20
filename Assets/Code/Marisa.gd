extends KinematicBody2D

onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn")
onready var BONUS = preload("res://Assets/Scenes/Prefabs/Bonus.tscn")
export(float) var SPEED: float = 400
var POWER = 1
var BOMBS = 2
var LIVES = 3
var SCORE = 0
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
	self.add_to_group("player")
	
func _physics_process(delta):
	if $Sprite.rotation_degrees < 0: $Sprite.rotation_degrees += 50 * delta
	if $Sprite.rotation_degrees > 0: $Sprite.rotation_degrees -= 50 * delta
	$Hitbox.set_visible(Visible)	
	_manage_input(delta)
	velocity = move_and_slide(velocity)
	if position.y <  200:
		var bonuses = get_tree().get_nodes_in_group("bonus")
		for bonus in bonuses:
			bonus.Go_to_player = true		
	Global.parametrear(SCORE,POWER,BOMBS,LIVES)

#Controla el input
func _manage_input(delta):
	velocity = Vector2()
	speed = SPEED/2.5 if (Input.is_action_pressed("shift")) else SPEED #Esto no es lo más optimo pero queria probarlo jasja
	Visible = true if (Input.is_action_pressed("shift")) else false
	
	if Input.is_action_pressed("shoot" ) && can_Shoot: 
		_shoot()
		timer.start()	
	#Movimiento	CANNOT GO OUT OF BOUNDS
	if Input.is_action_pressed("left") && position.x > 70: 
		velocity.x -= 1
		if $Sprite.rotation_degrees > -8 : $Sprite.rotation_degrees -= 80 * delta
	if Input.is_action_pressed("right") && position.x < 790: 
		velocity.x += 1
		if $Sprite.rotation_degrees < 8 : $Sprite.rotation_degrees += 80 * delta		
	if Input.is_action_pressed("up") && position.y > 10: velocity.y -= 1
	if Input.is_action_pressed("down") && position.y < 680: velocity.y += 1
	
	velocity = velocity.normalized() * speed 
	
	if Input.is_action_just_pressed("bomb") && BOMBS > 0: 
		BOMBS -= 1
		_bomb()
	
#Crea una instancia de bala, la mete a la escena y despues le setea la posicion inicial arriba del jugador
func _shoot():
	var bullet = BULLET.instance()
	#Los valores de las balas del jugador no son customizables sin cambiar el codigo
	bullet.init(true,3,Vector2(0,-16),100,1)
	get_parent().add_child(bullet)
	bullet.global_position = Vector2(get_node("Sprite").global_position.x, get_node("Sprite").global_position.y - 60)
	bullet.damage = 3
	can_Shoot = false

func _can_Shoot():
	can_Shoot = true #Podes disparar cuando termina el timer

func _bomb():
	var balas = get_tree().get_nodes_in_group("bullets")
	var enemies = get_tree().get_nodes_in_group("enemies")
	var bonuses = get_tree().get_nodes_in_group("bonus")
	for bala in balas:#Busca el grupo balas y enemigos y los PUTO MATA CHAVAL
		var bonus = BONUS.instance()
		bonus.position = bala.position
		bonus.init("CLEAR",10000,true)
		bonus.scale = Vector2(2,2)
		get_parent().call_deferred("add_child", bonus)			
		bala.queue_free() 			
	for enemy in enemies:
		enemy._recieve_damage(80) #Hace que los enemigos reciban X daño
	for bonus in bonuses:
		bonus.Go_to_player = true

func _on_Hurtbox_area_entered(area):
	var name = area.name.to_upper()
	if name == "PLAYER_CATCH" :
		_manage_catch(area.get_parent())
		area.get_parent().queue_free()
	if name == "HITBOX_BONUS" :
		area.get_parent().Go_to_player = true
	if name == "HITBOX_BULLET" || name == "HURTBOX_ENEMY":
		$Sound.play()
		LIVES -= 1
	
func _manage_catch(var bonus):
	var type = bonus.TYPE
	match type:
		"POWER":
			if POWER < 3.95 : 
				POWER += 0.05
		"BOMB":
			BOMBS += 1
		"EXTEND":
			LIVES += 1
	SCORE+= bonus.POINTS

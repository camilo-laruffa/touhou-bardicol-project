extends KinematicBody2D

onready var BULLET = preload("res://Assets/Scenes/Prefabs/Bullet.tscn")
onready var BONUS = preload("res://Assets/Scenes/Prefabs/Bonus.tscn")
onready var BOMB = preload("res://Assets/Scenes/Prefabs/Bomb.tscn")
export(float) var SPEED: float = 400
var POWER = 1
var BOMBS = 2
var LIVES = 3
var SCORE = 0
var velocity = Vector2()
var speed
const CD = 0.05
var can_Shoot = true
var Visible = false
var timer = Timer.new() #Este timer es el del disparo
var bomb_damage = 80

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
		AudioManager.play("Player Shot")
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
		AudioManager.play("Player Bomb")
		var bomb = BOMB.instance()
		bomb.position = position
		get_parent().add_child(bomb)
		BOMBS -= 1
		_bomb()
	
#Crea una instancia de bala, la mete a la escena y despues le setea la posicion inicial arriba del jugador
func _shoot():
	#Los valores de las balas del jugador no son customizables sin cambiar el codigo
	var Bullets = {}
	var power = int(round(POWER))
	var shooting_points = {}
	match power:
		1:
			shooting_points[0] = 0
		2:
			shooting_points[0] = -1
			shooting_points[1] = 1
		3:
			shooting_points[0] = -1
			shooting_points[1] = 0
			shooting_points[2] = 1
		4:
			shooting_points[0] = -2
			shooting_points[1] = -1
			shooting_points[2] = 0
			shooting_points[3] = 1
			shooting_points[4] = 2
	#Esto es como un full power
	if power == 4 : power = 5
	for index in range(0,power):
		Bullets[index] = BULLET.instance()
		Bullets[index].init(true,3,Vector2(shooting_points[index],-10),100,1)
		get_parent().add_child(Bullets[index])
		Bullets[index].global_position = Vector2(get_node("Sprite").global_position.x, get_node("Sprite").global_position.y - 40)
		Bullets[index].z_index -= 1
		if shooting_points[index] != 0 :
			var angle = 1.5708 - atan(10/abs(shooting_points[index])) 
			if shooting_points[index] < 0 :
				Bullets[index].rotation -= angle
				Bullets[index].global_position.y += abs(shooting_points[index] * 20)
			else :
				Bullets[index].rotation += angle
				Bullets[index].global_position.y += abs(shooting_points[index] * 20)
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
		enemy._recieve_damage(bomb_damage) #Hace que los enemigos reciban X daño
	for bonus in bonuses:
		bonus.Go_to_player = true

func _on_Hurtbox_area_entered(area):
	var name = area.name.to_upper()
	if name == "PLAYER_CATCH" :
		_manage_catch(area.get_parent())
		area.get_parent().queue_free()
	if name == "HITBOX_BONUS" :
		area.get_parent().Go_to_player = true
	if name == "HITBOX_BULLET" && area.get_parent().Player_bullet == false : 
		_die()
	if name == "HURTBOX_ENEMY":
		_die()

func _die():
	AudioManager.play("Player Miss")
	var death_bomb = BOMB.instance()
	death_bomb.position = position
	death_bomb.modulate.r = 0
	get_parent().add_child(death_bomb)
	bomb_damage = 10000
	_bomb()
	bomb_damage = 80
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
	SCORE += floor(bonus.POINTS * position.y)
	$Control/Label.visible = true
	$Control/Label.text = str(floor(bonus.POINTS * position.y))
	$Control/Timer.start()


func _on_Timer_timeout():
	$Control/Label.visible = false

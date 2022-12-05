extends KinematicBody2D

export(float) var HP: float = 100 
export(float) var LIFES: float = 3 
var lifes
var hp
var move_right = true
var speed = 3

func _ready():
	set_physics_process(true)
	hp = HP
	lifes = LIFES
	pass
	
func _physics_process(delta):
	if self.global_position.x < 80 : move_right = true
	if self.global_position.x > 620 : move_right = false
	if(move_right):
		self.global_position.x += speed
	else : self.global_position.x -= speed


func _on_HurtBox_area_entered(hitbox):
	_recieve_damage(hitbox.damage)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lifes -= 1
		hp = HP
	if (lifes <= 0): queue_free() 

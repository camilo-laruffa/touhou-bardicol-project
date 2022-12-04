extends KinematicBody2D

enum {LIFES = 3, HP = 100}
var hp
var lifes

func _ready():
	set_physics_process(true)
	hp = HP
	lifes = LIFES
	pass
	
func _physics_process(delta):
	print(hp)

func _on_HurtBox_area_entered(hitbox):
	_recieve_damage(hitbox.damage)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lifes -= 1
		hp = HP
	if (lifes <= 0): queue_free() 

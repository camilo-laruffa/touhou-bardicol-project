extends "res://Assets/Code/Enemy.gd"


var time = 0
var move_left = true 

func _ready():
	SPEED = 40
	pass
	
func _process(delta):
	time += delta
	if time < 3 : 
		move_and_slide(Vector2(0,1).normalized() * SPEED)
	pass
	
#func _shoot(parameter):
#	pass

	
func _on_Spellcard_Timer_timeout():
	#Siguiente spellcard
	pass # Replace with function body.

extends Node2D


onready var text = get_node("Texto")
var trayectory
var enemy

func _ready():	
	set_physics_process(true)
	trayectory = get_node("Player")
	text.ALIGN_CENTER


func _physics_process(delta):
	text.clear()
	
	enemy = get_node("Enemy")
	if enemy != null : 
		text.add_text(str(enemy.hp))

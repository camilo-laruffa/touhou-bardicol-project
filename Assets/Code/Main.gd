extends Node2D


onready var text = get_node("Texto")
var trayectory
var enemy

func _ready():	
	set_physics_process(true)
	trayectory = get_node("Player")
	text.ALIGN_CENTER


func _physics_process(delta):
	pass

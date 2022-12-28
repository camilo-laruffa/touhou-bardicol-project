extends Node2D

onready var Player = preload("res://Assets/Scenes/Player.tscn")
onready var Wave = [preload("res://Assets/Scenes/Levels/wave_1.tscn"),
					preload("res://Assets/Scenes/Levels/wave_2.tscn"),
					preload("res://Assets/Scenes/Levels/big_enemy_1.tscn")]

func _ready():	
	set_physics_process(true)
	#Todavia estamos trabajando en stage/wave manager
	var player = Player.instance()
	add_child(player)
	player.position = Vector2(300,530)
	var wave = Wave[1].instance()	
	wave.position = Vector2(0,0)
	add_child(wave)
	wave = Wave[2].instance()
	add_child(wave)	
	
	


func _physics_process(delta):
	pass

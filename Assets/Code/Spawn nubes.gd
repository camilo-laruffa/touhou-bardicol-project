extends Node2D

onready var NUBE = preload("res://Assets/Scenes/Cloud.tscn")
export(float) var CD : float = 1

var timer = Timer.new() 

func _ready():
	set_physics_process(true)
	_spawnear()
	add_child(timer)
	timer.set_one_shot(true)
	timer.set_wait_time(CD) #Cada CD seg puede disparar
func _process(delta):
	if(timer.is_stopped()):
		_spawnear()
		timer.start()
		
func _spawnear():
	var nube = NUBE.instance()	
	get_parent().add_child(nube)
	nube.global_position = Vector2(self.global_position.x, self.global_position.y)
	nube.z_index = -2
	

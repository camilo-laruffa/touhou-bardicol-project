extends Node2D

onready var Player = preload("res://Assets/Scenes/Player.tscn")
onready var Wave = [preload("res://Assets/Scenes/Levels/wave_1.tscn"),
					preload("res://Assets/Scenes/Levels/wave_2.tscn"),
					preload("res://Assets/Scenes/Levels/wave_pre_3.tscn"),
					preload("res://Assets/Scenes/Levels/wave_3.tscn"),
					preload("res://Assets/Scenes/Levels/wave_post_3.tscn"),
					preload("res://Assets/Scenes/Levels/big_enemy_1.tscn")]
var wave_timer = Timer.new()
var wave
var wave_duration
var w_index = 0

func _ready():	
	#Todavia estamos trabajando en stage/wave manager
	var player = Player.instance()
	wave = Wave[0].instance()
	wave_duration = wave.duration
	add_child(player)
	add_child(wave_timer)
	wave_timer.set_wait_time(wave_duration)
	wave_timer.set_one_shot(true)
	wave_timer.start()
	player.position = Vector2(300,530)
	add_child(wave)


func _process(delta):
	if wave_timer.is_stopped():
		if Wave.size() > w_index : 
			_next_wave()
			wave_timer.set_wait_time(wave_duration)
			wave_timer.start()

func _next_wave():
	w_index += 1
	if Wave.size() > w_index : 
		print("Instancing new Wave..")
		wave = Wave[w_index].instance()
		wave_duration = wave.duration
		add_child(wave)


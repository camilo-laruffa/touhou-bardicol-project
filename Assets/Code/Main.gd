extends Node2D

onready var Player = preload("res://Assets/Scenes/Player.tscn")
onready var Wave = [preload("res://Assets/Scenes/Levels/wave_1.tscn"),
					preload("res://Assets/Scenes/Levels/wave_2.tscn"),
					preload("res://Assets/Scenes/Levels/big_enemy_1.tscn")]
var wave_timer = Timer.new()
var wave
var wave_duration
var w_index = 0

func _ready():	
	#Todavia estamos trabajando en stage/wave manager
	var player = Player.instance()
	add_child(player)
	wave_timer.set_wait_time(0)
	wave_timer.set_one_shot(true)
	add_child(wave_timer)
	player.position = Vector2(300,530)

func _process(delta):
	if w_index >= Wave.size() : w_index = 0
	if wave_timer.is_stopped() :
		print(w_index)
		if w_index < Wave.size():
			_next_wave()
			wave_timer.set_wait_time(wave_duration)
			wave_timer.start()

func _next_wave():
	wave = Wave[w_index].instance()
	wave_duration = wave.duration
	call_deferred("add_child",wave)
	w_index += 1

extends Node2D


func _ready():
	sfx_volume(Global.sfx_volume)
	music_volume(Global.music_volume)
	pass

func play_music():
	if !$Music.playing :
		$Music.play()

func music_volume(volume):
	$Music.volume_db = volume

func sfx_volume(volume) : 
	var audios = get_tree().get_nodes_in_group("SFX")
	for sfx in audios :
		sfx.volume_db = volume
		

func stop_music():
	$Music.stop()
	
func change_music(musica):
	stop_music()
	$Music.stream = load(musica)
	play_music()

func play(music):
	music = music.to_upper()
	match music:
		"ENEMY CIRCLE SHOT":
			$Enemy_CircleShot.play()
		"ENEMY NORMAL SHOT":
			$Enemy_NormalShot.play()
		"PLAYER SHOT":
			$Player_Shot.play()
		"PLAYER MISS":
			$Player_Death.play()
		"PLAYER BOMB":
			$Player_Bomb.play()
			

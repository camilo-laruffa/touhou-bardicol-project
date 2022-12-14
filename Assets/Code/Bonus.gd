extends KinematicBody2D

onready var SPRITE = get_node("Sprite")
onready var timer = get_node("Timer")
export(int) var frame: int = 19
var direction = Vector2(0,1)
var Go_to_player = false
var speed = 50
var POINTS = 1
var TYPE 

func init(var type: String, var points: int, var go_to_player: bool):
	type = type.to_upper()
	match type:
		"POWER":
			frame = 16
		"POINT":
			frame = 17
		"BOMB":
			frame = 18
		"EXTEND":
			frame = 19
		"CLEAR":
			frame = 20
	TYPE = type
	POINTS = points
	Go_to_player = go_to_player

func _ready():
	SPRITE.frame = frame
	self.add_to_group("bonus")
	pass
		
func _process(delta):
	_chequear_despawn()
	direction = Vector2(0,1)
	if !timer.is_stopped() :
		direction = Vector2(0,-1)
	if Go_to_player:
		var player_position = get_tree().get_nodes_in_group("player")[0].position
		direction = position.direction_to(player_position)
		speed = 600
		look_at(player_position)
		rotation -= PI/2
	move_and_slide(direction * speed)
	pass

func _chequear_despawn():	
	if position.x > 900 || position.x < 20:
		queue_free()
	if position.y > 720:
		queue_free()

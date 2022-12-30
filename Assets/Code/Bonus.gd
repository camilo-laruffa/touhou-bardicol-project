extends KinematicBody2D

var POINTS = 1
onready var SPRITE = get_node("Sprite")
export(int) var frame: int = 19
var direction = Vector2(0,1)
var Go_to_player = false
var speed = 150

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
	POINTS = points
	Go_to_player = go_to_player

func _ready():
	set_physics_process(true)
	SPRITE.frame = frame
	self.add_to_group("bonus")
	pass
	
func _physics_process(delta):
	if Go_to_player:
		var player_position = get_tree().get_nodes_in_group("player")[0].position
		direction = position.direction_to(player_position)
		speed = 400
		look_at(player_position)
		rotation -= PI/2
	move_and_slide(direction * speed)
	pass

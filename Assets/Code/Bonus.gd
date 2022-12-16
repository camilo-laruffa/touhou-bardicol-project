extends Node2D

var POINTS = 1
onready var SPRITE = get_node("Sprite")
var frame = 19

func init(var type: String, var points: int):
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

func _ready():
	set_physics_process(true)
	SPRITE.frame = frame
	pass
	
func _physics_process(delta):
	position.y += 300 * delta
	pass

extends Node

var damage: int = 0
var player_bullet = false

func _ready():
	damage = get_parent().damage
	pass 



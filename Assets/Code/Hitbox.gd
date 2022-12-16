extends Node

#Todo esto es para que se pueda ver en el inspector
#Es como un [SerializedField] de Unity
var damage: int = 0
var player_bullet = false

func _ready():
	damage = get_parent().damage
	print("Parent damage = ", damage)
	pass # Replace with function body.



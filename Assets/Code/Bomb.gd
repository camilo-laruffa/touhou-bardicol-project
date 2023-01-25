extends Node2D


func _ready():
	pass

func _process(delta):
	$Sprite.scale.x += 150 * delta 	
	$Sprite.scale.y += 150 * delta 	
	$Sprite.rotation += 5 * delta
	$Sprite.modulate.a -= delta
	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.

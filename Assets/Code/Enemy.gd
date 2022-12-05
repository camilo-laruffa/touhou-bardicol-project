extends Node2D

export(float) var HP: float = 100 
export(int) var LIFES: int = 3 
export(int) var FRAME: int = 13
onready var SPRITE_SHEET = preload("res://Assets/Sprites/marisa_spritesheet.png")
onready var sprite = get_node("Sprite")
const e = 2.71828182846
var horizontal=1
var vertical=1
var lifes
var hp
var move_right = true
var speed = 100
func _ready():
	set_physics_process(true)
	sprite.texture = SPRITE_SHEET
	sprite.frame = FRAME
	hp = HP
	lifes = LIFES
	pass
	
func _physics_process(delta):
	if self.global_position.x < 80 : move_right = true
	if self.global_position.x > 620 : move_right = false
	if(move_right):
		self.global_position.x += speed * delta
	else : self.global_position.x -= speed * delta
	pass


func _on_HurtBox_area_entered(hitbox):
	_recieve_damage(hitbox.damage)

func _recieve_damage(damage):
	hp -= damage
	if (hp <= 0): 
		lifes -= 1
		hp = HP
	if (lifes <= 0): queue_free() 

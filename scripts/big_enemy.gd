extends Area2D

@export var speed = 0
var dmg_ratio = 2
var bonus = 2

signal die_enemy(bonus: int)

func _ready():
	
	self.connect("body_entered", _on_body_entered)

func _physics_process(delta):

	global_position.x -= speed * delta


func die():

	emit_signal("die_enemy", bonus)
	queue_free()


func _on_body_entered(body):
	
	if body.name == "player":
		body.take_damage(dmg_ratio)
		die()


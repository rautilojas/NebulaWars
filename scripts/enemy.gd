extends Area2D

@export var speed = randi_range(100, 500)
var dmg_ratio = 1
var bonus = 1

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


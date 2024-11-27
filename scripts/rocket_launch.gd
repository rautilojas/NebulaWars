extends Area2D

@export var speed = 500

@onready var visible_notifier: Node = $VisibleNotifier

func _ready():

	visible_notifier.connect("screen_exited", _on_screen_exited)
	self.connect("area_entered", _on_area_entered)


func _physics_process(delta):

	global_position.x += speed * delta


func _on_screen_exited():

	queue_free()


func _on_area_entered(area):
	
	queue_free()
	
	if area.has_method("die"):
		area.die()

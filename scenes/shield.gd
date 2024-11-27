extends Area2D

func _ready():
	
	self.connect("body_entered", _on_body_entered)
	

func _on_body_entered(body):
	
	if body.name == "player":
		body.shield_armed()
		self.queue_free()

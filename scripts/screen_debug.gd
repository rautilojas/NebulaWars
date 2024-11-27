extends CanvasLayer

var fps = 0


func _physics_process(_delta):
	fps = Engine.get_frames_per_second()
	
	self.get_children()[0].set_text(str(fps) + "FPS")


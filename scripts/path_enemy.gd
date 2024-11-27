extends Path2D

@onready var path = $PathFollow2D
@onready var enemy = $PathFollow2D/big_enemy


func _ready():
	
	path.set_progress_ratio(1)


func _process(delta):
	
	path.progress_ratio -= 0.25 * delta

	if path.progress_ratio == 0.0001:
		enemy.queue_free()


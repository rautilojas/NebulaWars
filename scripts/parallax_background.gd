extends ParallaxBackground

var scroll_speed: Vector2 = Vector2(100, 0)


func _process(delta):

	scroll_base_offset -= scroll_speed * delta

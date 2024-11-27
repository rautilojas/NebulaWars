extends Node2D

var shield_scene = preload("res://scenes/shield.tscn")
var powerups: Array = []

@onready var spawn_timer = $spawn_timer
@onready var life_span_timer = $life_span_timer
@onready var spawn_points = $spawn_positions

signal shield_spawned(shield: Node)
signal life_span_expired


func _ready():

	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	spawn_timer.set_wait_time(randi_range(5, 10))
	spawn_timer.start()

	life_span_timer.connect("timeout", _on_life_span_timer_timeout)
	life_span_timer.set_wait_time(5)

func _on_spawn_timer_timeout():

	var shield = shield_scene.instantiate()
	shield.global_position = spawn_points.get_children().pick_random().global_position
	add_child(shield)

	powerups.append(shield)

	emit_signal("shield_spawned", shield)

	spawn_timer.set_wait_time(randi_range(5, 10))
	spawn_timer.start()
	life_span_timer.start()

func _on_life_span_timer_timeout():
	
	if powerups.size() > 0:
		var power_up = powerups.pop_front()
		
		if power_up != null:
			power_up.queue_free()

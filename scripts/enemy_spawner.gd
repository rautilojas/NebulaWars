extends Node2D

var enemy_scene = preload("res://scenes/enemy.tscn")
var big_enemy_scene = preload("res://scenes/path_enemy.tscn")

var enemy_types: Dictionary = {
	0: enemy_scene,
	1: big_enemy_scene
}

@onready var spawn_positions: Node = $spawn_positions
@onready var multiple_enemy_timer: Node = $multiple_enemy_timer
@onready var path_timer: Node = $path_timer

signal enemy_spawned(enemy_isntance: Node)
signal path_enemy_spawned(path_enemy_instance: Node)

func _ready():

	multiple_enemy_timer.connect("timeout", _on_multiple_enemy_timeout)
	multiple_enemy_timer.set_wait_time(randf_range(0.2, 2))
	multiple_enemy_timer.start()

	path_timer.connect("timeout", _on_path_enemy_timeout)
	path_timer.set_wait_time(randf_range(1.5, 4))
	path_timer.start()

func _on_multiple_enemy_timeout():
	
	spawn_enemy(enemy_types[0])
	multiple_enemy_timer.set_wait_time(randf_range(0.2, 2))
	multiple_enemy_timer.start()


func _on_path_enemy_timeout():

	spawn_enemy(enemy_types[1])
	path_timer.set_wait_time(randf_range(1.5, 4))
	path_timer.start()


func spawn_enemy(escene: PackedScene = enemy_scene):

	var enemy = escene.instantiate()

	match escene:
		enemy_scene:
			var rdm_spawn_point = spawn_positions.get_children().pick_random().global_position
			enemy.global_position = rdm_spawn_point
			emit_signal("enemy_spawned", enemy)
			return

		big_enemy_scene:
			emit_signal("path_enemy_spawned", enemy)
			return

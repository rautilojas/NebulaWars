extends CharacterBody2D

var keys: Dictionary = {
	"move_up": Vector2(0, -1),
	"move_down": Vector2(0, 1),
	"move_left": Vector2(-1, 0),
	"move_right": Vector2(1, 0)
}

@export var speed = 20000

var rocket_scene: PackedScene = preload("res://scenes/rocket.tscn")
var shield_scene: PackedScene = preload("res://scenes/player_shield.tscn")
var shield

@onready var rocket_container: Node = $rocket_container

signal took_damage(dmg: int)
signal shot

@onready var has_energy: bool = true
@onready var has_shield: bool = false

func _ready():
	
	get_parent().connect("energy_depleted", _on_energy_depleted)
	get_parent().connect("rearmed", _on_rearmed)


func _physics_process(delta):
	
	velocity = Vector2()

	throtle()

	apply_velocity(delta)

	clamping_player_position()


func _input(event):

	if event.is_action_pressed("shoot"):
		shoot_rocket()


func throtle() -> void:

	for key in keys.keys():
		if Input.is_action_pressed(key):
			velocity += keys[key]


func apply_velocity(delta: float):
	
	velocity = velocity.normalized() * speed * delta
	move_and_slide()


func clamping_player_position():
	
	global_position = global_position.clamp(Vector2(0, 0), get_viewport().size)


func shoot_rocket():

	if !has_energy:
		return

	emit_signal("shot")

	var rocket = rocket_scene.instantiate()
	rocket_container.add_child(rocket)

	rocket.global_position = global_position
	rocket.global_position.x += 60


func take_damage(dmg: int):
	
	if has_shield:
		shield.queue_free()
	
	emit_signal("took_damage", dmg)


func die():

	queue_free()
	print("Game Over")
	


func _on_energy_depleted():
	
	has_energy = false
	

func _on_rearmed():
	
	has_energy = true
	

func shield_armed():
	
	if not has_shield:
		has_shield = true
		spawn_shield()
	

func spawn_shield():
	
	shield = shield_scene.instantiate()
	add_child(shield)

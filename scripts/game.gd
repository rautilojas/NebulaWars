extends Node2D

@onready var deathzone: Node = $deathzone
@onready var player: Node = $player
@onready var enemy_spawner: Node = $enemy_spawner
@onready var ui: Node = $ui
@onready var hud: Node = $ui/hud

var lives: int
var score: int
var energy: float

@onready var game_over_scene: PackedScene = preload("res://scenes/game_over.tscn")

@onready var hit_fx:  AudioStreamPlayer = $sound_fx/enemy_hit_sound
@onready var death_fx:  AudioStreamPlayer = $sound_fx/explode
@onready var shoot_fx:  AudioStreamPlayer = $sound_fx/laser
@onready var energy_depleted_fx:  AudioStreamPlayer = $sound_fx/energy_depleted
@onready var player_hit_fx:  AudioStreamPlayer = $sound_fx/player_hit

@onready var music: AudioStreamPlayer = $music/AudioStreamPlayer

signal energy_depleted
signal rearmed

func _ready():

	deathzone.connect("area_entered", _on_area_entered)
	player.connect("took_damage", _on_took_damage)
	enemy_spawner.connect("enemy_spawned", _on_enemy_spawned)
	enemy_spawner.connect("path_enemy_spawned", _on_path_enemy_spawned)
	player.connect("shot", _on_shot)
	music.connect("finished", _on_music_finished)

	lives = 3
	score = 0
	energy = 100

	hud.set_score_label(score)


func _process(delta):

	if energy <= 0:
		energy_depleted_fx.play()

	if energy > 9:
		emit_signal("rearmed")
	
	if energy <= 100:
		energy += 10 * delta
		hud.set_energy(energy)


func _on_area_entered(area):
	
	if area.has_method("die"):
		area.queue_free()


func _on_took_damage(dmg):
	
	if player.has_shield:
		player.has_shield = false
		return
			
	if lives > 0:
		lives -= dmg
		for i in range(dmg):
			hud.lose_life()
		player_hit_fx.play()
		return

	end_game()


func _on_enemy_spawned(enemy_instance):

	enemy_instance.connect("die_enemy", _on_enemy_died)
	add_child(enemy_instance)


func _on_path_enemy_spawned(path_enemy_instance):
	
	add_child(path_enemy_instance)
	path_enemy_instance.enemy.connect("die_enemy", _on_enemy_died)
	


func _on_enemy_died(bonus):
	
	score += bonus * 100
	hud.set_score_label(score)
	hit_fx.play()


func _on_shot():

	if energy > 0:
		energy -= 10
		hud.set_energy(energy)
		shoot_fx.play()
		
		return

	emit_signal("energy_depleted")

func end_game():

	death_fx.play()

	player.die()

	await get_tree().create_timer(1.5).timeout
	
	var game_over = game_over_scene.instantiate()
	game_over.set_score(score)

	ui.add_child(game_over)


func _on_music_finished():
	
	music.play()

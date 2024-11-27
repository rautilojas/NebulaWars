extends Control

@onready var button: Button = $Panel/retry_btn


func _ready():

	button.connect("pressed", _on_retry_btn_pressed)


func _on_retry_btn_pressed():

	get_tree().reload_current_scene()


func set_score(current_score: int):
	
	$Panel/score.text = str(current_score)


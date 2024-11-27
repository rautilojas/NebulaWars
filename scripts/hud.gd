extends Control

@onready var score: Label = $score
@onready var lifes: Array = $lifes.get_children()
@onready var energy: ProgressBar = $energy

func set_score_label(new_score: int):
	
	score.text = "SCORE: " + str(new_score)


func lose_life():
	
	if lifes.size() > 0:
		lifes.pop_back().queue_free()


func set_energy(new_energy: float):
	
	energy.value = new_energy


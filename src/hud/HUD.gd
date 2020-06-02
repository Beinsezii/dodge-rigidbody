extends CanvasLayer

signal start_game
signal game_ready


# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.hide()
	$StartButton.hide()


func show_new_game():
	$Message.text = "Current\nObjective:\n\nSurvive"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	emit_signal("game_ready")


func update_score(score):
	$ScoreCounter.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$StartButton.hide()
	$Message.hide()
	emit_signal("start_game")

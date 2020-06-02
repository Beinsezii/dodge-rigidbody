extends Node

export (PackedScene) var Mob
export (PackedScene) var Player
var score
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	ready_game()


func start_game():
	score = 0
	$HUD.update_score(score)
	player.controllable = true
	$StartTimer.start()
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$HUD/Message.text = "game over"
	$HUD/Message.show()
	yield(get_tree().create_timer(1), "timeout")
	ready_game()
	

func ready_game():
	player = Player.instance()
	player.position = $StartPosition.position
	player.controllable = false
	add_child(player)
	$HUD.show_new_game()


func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func kill_area(body):
	if body == player:
		$StartTimer.stop()
		player.kill()
		player = null
		game_over()

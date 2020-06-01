extends Node

export (PackedScene) var Mob
export (PackedScene) var Player
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func new_game():
	var player = Player.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect('dead', self, 'game_over')
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("")
	player.show()
	$StartTimer.start()
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$HUD.show_game_over()


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
	# Set the velocity (speed & direction).
	mob.speed = rand_range(mob.min_speed, mob.max_speed)
	var mobscale = rand_range(mob.min_scale, mob.max_scale)
	mob.scale = Vector2(mobscale, mobscale)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

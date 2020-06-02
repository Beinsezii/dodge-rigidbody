extends RigidBody2D

export var min_speed = 10
export var max_speed = 20
export var min_curve = 0.0
export var max_curve = 0.25
export var min_scale = 0.5
export var max_scale = 1.5
var speed = 1
var curve = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $CollisionShape2D/AnimatedSprite.frames.get_animation_names()
	$CollisionShape2D/AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	speed = rand_range(min_speed, max_speed)
	curve = clamp(
		rand_range(min_curve, pow(max_curve, 2)),
		0, 1
		)
	if randi()%2: curve = -curve
	var newscale = rand_range(min_scale, max_scale)
	$CollisionShape2D.scale = Vector2(newscale, newscale)
	mass *= pow(newscale, 2)
	speed /= mass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _integrate_forces(state):
	var tf = state.transform
	
	state.angular_velocity += curve
	state.linear_velocity += Vector2(speed, 0).rotated(tf.get_rotation())

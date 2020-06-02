extends RigidBody2D
signal dead


export var speed: float = 25
export var turn_speed: float = 0.5
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.speed_scale = min(3, linear_velocity.length() * 0.01)


func kill():
	emit_signal("dead")
	sleeping=true
	$AnimatedSprite.speed_scale = 1
	$AnimatedSprite.animation = 'explode'
	yield($AnimatedSprite, "animation_finished")
	queue_free()


# adds angular velocity towards target
func look_towards(state, tf, target: Vector2, speedmod=1.0):
	# secret black magic sauce.
	var dir = tf.origin.direction_to(target).rotated(-tf.get_rotation()).angle()
	state.angular_velocity += dir * speedmod


func _integrate_forces(state):
	# Movement
	var tf = state.transform
	var lv_mod: Vector2 = Vector2()
	if Input.is_mouse_button_pressed(1):
		lv_mod += Vector2(speed, 0).rotated(tf.get_rotation())
	
	look_towards(state, get_global_transform(), get_global_mouse_position())

	state.linear_velocity += lv_mod

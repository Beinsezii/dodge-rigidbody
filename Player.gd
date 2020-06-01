extends RigidBody2D
signal dead


export var speed: float = 50
export var turn_speed: float = 0.5
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > screen_size.y or position.x > screen_size.x\
	or position.y < 0 or position.x < 0:
		kill()
	$AnimatedSprite.speed_scale = min(3, linear_velocity.length() * 0.01)


func kill():
	emit_signal("dead")
	$AnimatedSprite.speed_scale = 1
	$AnimatedSprite.animation = 'explode'
	yield($AnimatedSprite, "animation_finished")
	queue_free()


# dead to me
func look_at_pos(state, tf, target):
	var diff = tf.get_rotation() - target.angle_to_point(tf.origin)
	if diff < -PI: diff += PI
	print(diff, ' ', tf.get_rotation())
	if Input.is_action_pressed("ui_accept"):
		state.angular_velocity += diff


func _integrate_forces(state):
	# Movement
	var tf = state.transform
	var lv_mod: Vector2 = Vector2()
	var av_mod: float = 0
	if Input.is_action_pressed("ui_up"):
		lv_mod += Vector2(speed, 0).rotated(tf.get_rotation())
	if Input.is_action_pressed("ui_down"):
		lv_mod -= Vector2(speed, 0).rotated(tf.get_rotation())
	
	if Input.is_action_pressed("ui_left"):
		av_mod -= turn_speed
	if Input.is_action_pressed("ui_right"):
		av_mod += turn_speed
	
	$AnimatedSprite.flip_h = state.angular_velocity < 0

	state.linear_velocity += lv_mod
	state.angular_velocity += av_mod

extends RigidBody2D
signal dead


export var speed: float = 25
export var turn_speed: float = 0.5
var controllable: bool = true

# Called when the node enters the scene tree for the first time.
# func _ready():
	# pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Body/Sclera.look_at(get_global_mouse_position())


func kill():
	emit_signal("dead")
	controllable=false
	sleeping=true
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	yield($Explosion, "animation_finished")
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
	if Input.is_mouse_button_pressed(1) && controllable:
		lv_mod += Vector2(speed, 0).rotated(tf.get_rotation())
	
	look_towards(state, get_global_transform(), get_global_mouse_position())

	state.linear_velocity += lv_mod

extends RigidBody2D

export var min_speed = 3  # Minimum speed range.
export var max_speed = 10  # Maximum speed range.
export var min_scale = 0.1
export var max_scale = 2.0
var speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _integrate_forces(state):
	var tf = state.transform
	var lv_mod: Vector2 = Vector2()
	lv_mod += Vector2(speed, 0).rotated(tf.get_rotation())

	state.linear_velocity += lv_mod

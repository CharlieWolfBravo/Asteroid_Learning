extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const move_speed = 250
const acceleration = 1
const deceleration = 0.01

var motion = Vector2(0,0)
var direction = Vector2(0,0)

var screen_size
var screen_buffer = 8

var spawn_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

func _process(delta):
	motion = motion.linear_interpolate(direction, acceleration)
	position += motion * move_speed * delta
	
	# Check distance for frame switch
	spawn_time += 1
	print("Spawn time:", spawn_time)
	print("delta:", delta)
	if spawn_time % 10 == 0:
		var sprite = get_child(0)
		sprite.frame = sprite.frame+1 % 3
		spawn_time = 0
	check_out_of_bounds()
	
func check_out_of_bounds():
	if position.x < (0 - screen_buffer) or position.x > (screen_size.x + screen_buffer):
		print("Deleted!")
		get_parent().remove_child(self)
	if position.y < (0 - screen_buffer) or position.y > (screen_size.y + screen_buffer):
		print("Deleted!")
		get_parent().remove_child(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

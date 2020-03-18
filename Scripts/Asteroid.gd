extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const max_move_speed = 110
const max_rot_speed = 160
const acc = 0.05
const dec = 0.01

const max_scale = 1
const min_scale = 0.5

var screen_size
var screen_buffer = 8

var move_dir
var motion = Vector2(0,0)

var rotation_speed

signal player_collision
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = get_viewport_rect().size

	# TODO Random place
	self.position.x = rand_range(0, screen_size.x)
	self.position.y = rand_range(0, screen_size.y)
	# TODO Random size
	self.scale.x = rand_range(min_scale, max_scale)
	self.scale.y = rand_range(min_scale, max_scale)
	# TODO random starting rotation
	rotation_speed = randf()
	self.rotation_degrees = rand_range(0,360)
	# TODO movement direction
	move_dir = Vector2(rand_range(-1,1), rand_range(-1,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Continue moving in assigned direction
	motion = motion.linear_interpolate(move_dir, acc)
	self.position += motion * max_move_speed * delta

	# Rotation
	self.rotation_degrees += rotation_speed * max_rot_speed * delta
	
	# Screen Wrapping
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)
	
	# Dectect collision

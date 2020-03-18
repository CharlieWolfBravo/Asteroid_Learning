extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const turn_speed = 180

const max_move_speed = 150
const acceleration = 0.05
const decceleration = 0.01

var motion = Vector2(0,0)

var screen_size
var screen_buffer = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Input.is_action_pressed("ui_left"):
		self.rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		self.rotation_degrees += turn_speed * delta
		
	var move_dir = Vector2(1,0).rotated(self.rotation)
	var sprite = get_child(0)
	if Input.is_action_pressed("ui_up"):
		motion = motion.linear_interpolate(move_dir, acceleration)
		sprite.frame = 1
	else:
		motion = motion.linear_interpolate(Vector2(0,0), decceleration)
		sprite.frame = 0
		
	self.position += motion * max_move_speed * delta
	
	# Screen Wrapping
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

func _detect_asteroid_collision():
	

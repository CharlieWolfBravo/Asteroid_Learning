extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const turn_speed = 180

const max_move_speed = 150
const acceleration = 0.08
const deceleration = 0.01

var current_acc_direction = Vector2.ZERO
var last_frame_position = Vector2.ZERO

var screen_size
var screen_buffer = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Player inputs
	if Input.is_action_pressed("ui_left"):
		self.rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		self.rotation_degrees += turn_speed * delta
		
	if Input.is_action_just_pressed("ui_shoot"):
		shoot_projectile()
		
	var move_dir = Vector2(1,0).rotated(self.rotation)
	var sprite = get_child(0)
	if Input.is_action_pressed("ui_up"):
		current_acc_direction = current_acc_direction.linear_interpolate(move_dir, acceleration)
	else:
		current_acc_direction = current_acc_direction.linear_interpolate(Vector2(0,0), deceleration)
		
	self.position += current_acc_direction * max_move_speed * delta
	
	# Screen Wrapping
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

	sprite.frame = determine_frame(self.position, last_frame_position, delta)

	last_frame_position = self.position


func _on_player_area_entered(area):
	# We need to check which area to determine what to do
	print(area.name.substr(1,8))
	if area.name.substr(1,8) == 'Asteroid':
		reset_player()
		
func reset_player():
	self.position.x = screen_size.x/2
	self.position.y = screen_size.y/2
	self.rotation_degrees = 0.0
	self.current_acc_direction = Vector2(0,0)


func shoot_projectile():
	var scene = load("res://scenes/Projectile.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("Projectile")
	var projectile_direction = Vector2(1,0).rotated(self.rotation)
	#Now we need to send this bugger packing
	scene_instance.position = self.position
	scene_instance.direction = projectile_direction
	scene_instance.rotation_degrees = self.rotation_degrees
	get_parent().add_child(scene_instance)
	

func determine_frame(current_position, last_position, delta):
	# Determines the correct frame and returns that integer.
	# Currently supports the Spaceship_v1.
	
	if Input.is_action_pressed("ui_up"):
		var half_speed = 0.45 * max_move_speed
		var full_speed = 0.95 * max_move_speed

		var distance_traveled = (current_position - last_position)
		var speed_x = abs(distance_traveled.x / delta)
		var speed_y = abs(distance_traveled.y / delta)
		print(speed_x, speed_y)
		if speed_x > 0 or speed_y > 0:
			if speed_x >= full_speed or speed_y >= full_speed:
				return 3
			elif speed_x >= half_speed or speed_y >= half_speed:
				return 2
			else:
				return 1
		else:
			# Shouldn't happen, but who knows.
			return 0
	else:
		return 0

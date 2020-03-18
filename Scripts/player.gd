extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const turn_speed = 180

const max_move_speed = 150
const acceleration = 0.08
const deceleration = 0.01

var motion = Vector2(0,0)

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
		motion = motion.linear_interpolate(move_dir, acceleration)
		sprite.frame = 1
	else:
		motion = motion.linear_interpolate(Vector2(0,0), deceleration)
		sprite.frame = 0
		
	self.position += motion * max_move_speed * delta
	
	# Screen Wrapping
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)


func _on_player_area_entered(area):
	# We need to check which area to determine what to do
	print(area.name.substr(1,8))
	if area.name.substr(1,8) == 'Asteroid':
		reset_player()
		
func reset_player():
	self.position.x = screen_size.x/2
	self.position.y = screen_size.y/2
	self.rotation_degrees = 0.0
	self.motion = Vector2(0,0)


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

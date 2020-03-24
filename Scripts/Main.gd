extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	# Spawn a random number of asteroids
	for i in range(rand_range(10,30)):
		var scene = load("res://scenes/Asteroid.tscn")
		var asteroid = scene.instance()
		asteroid.set_name("Asteroid")
		add_child(asteroid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

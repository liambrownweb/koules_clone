extends Node2D
# Member variables
const zero_velocity = Vector2(0.0, 0.0)
var deg_direction
var direction = Vector2(1.0, 0.0)
var magnitude
var mouse_position
var player
var screen_size
var thrust_factor = 0.1
var unit_vector
var velocity = Vector2(0.0, 0.0)
var collision

func _ready():
    screen_size = get_viewport_rect().size
    set_process(true)

func _process(delta):
	player = get_node("Player")
	set_process_input(true)
	
	# Ship rotation based on mouse position
	mouse_position = get_local_mouse_position()
	direction[0] = player.position[0] - mouse_position[0] 
	direction[1] = player.position[1] - mouse_position[1] 
	magnitude = sqrt(pow(direction[0], 2) + pow(direction[1], 2))
	unit_vector = -thrust_factor * (direction / magnitude)
	deg_direction = -rad2deg(atan2(direction[0], direction[1]))
	player.rotation_degrees = deg_direction
	
	# Thrust control
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		velocity += unit_vector
	else:
		velocity *= .99
	if (velocity != zero_velocity):
		collision = get_node("Player").move_and_collide(velocity)
	if collision != null:
		print(collision.normal)
		player.killme()
		if collision.normal[0] != 0:
			velocity[0] *= -abs(collision.normal[0])
		if collision.normal[1] != 0:
			velocity[1] *= -abs(collision.normal[1])
	
# func _input(event):
extends Node2D
# Member variables
const zero_velocity = Vector2(0.0, 0.0)
var deg_direction
var direction = Vector2(1.0, 0.0)
var magnitude
var mouse_position
var player
var screen_size
var thrust_factor = 0
var thrust_max = 30
var unit_vector
var collision
var npcs

func _ready():
    screen_size = get_viewport_rect().size
    set_process(true)

func _process(delta):
	player = get_node("Player")
	npcs = get_node("Alien")
	set_process_input(true)
	
	npcs.setTarget(player)
	# Ship rotation based on mouse position
	mouse_position = get_local_mouse_position()
	direction[0] = player.position[0] - mouse_position[0] 
	direction[1] = player.position[1] - mouse_position[1] 
	magnitude = sqrt(pow(direction[0], 2) + pow(direction[1], 2))
	unit_vector = -(direction / magnitude)
	deg_direction = -rad2deg(atan2(direction[0], direction[1]))
	player.rotation_degrees = deg_direction
	
	# Thrust control
	if Input.is_mouse_button_pressed(BUTTON_LEFT) && thrust_factor < thrust_max:
		thrust_factor += 1
	else:
		thrust_factor *= .1
	player.set_applied_force(unit_vector * thrust_factor)
	if collision == null:
		doNothing()
	elif ("deadly" in collision.collider):
		player.killme()
	
func doNothing():
	return
# func _input(event):
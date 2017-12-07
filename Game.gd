extends Node2D
const Alien = preload("Alien.tscn")
const math = preload("math.gd")
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
var npcs = Array()

var alien

func _ready():
	screen_size = get_viewport_rect().size
	set_process(true)
	player = get_node("Player")
	for i in range(10):
		npcs.append(Alien.instance())
	for alien in npcs:
		add_child(alien)
		alien.setTarget(player)
	
	

func _process(delta):
	set_process_input(true)
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

func calculateRepulsorForceVector(burst_position, target_position, burst_force):
	var distance_vector = burst_position - target_position
	var unit_vector = math.calculateUnitVector(distance_vector)
	var distance_scalar = sqrt(pow(distance_vector[0], 2) + pow(distance_vector[1], 2))
	var coefficient = 0
	if distance_scalar > 0:
		coefficient = 1 / pow(distance_scalar, 2)
	return burst_force * coefficient * unit_vector
	
func setRepulsorBurstAt(burst_position, burst_force):
	var force_vector = calculateRepulsorForceVector(burst_position, player.position, burst_force)
	player.apply_impulse(zero_velocity, force_vector)
	for i in npcs:
		force_vector = calculateRepulsorForceVector(burst_position, i.position, burst_force)
		i.apply_impulse(zero_velocity, force_vector)
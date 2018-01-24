extends Node2D
const Alien = preload("Alien.tscn")
const math = preload("math.gd")
# Member variables

var camera
var mouse_position
var player
var screen_size

var collision
var npcs = Array()

var alien

func _ready():
	camera = get_node("Camera2D")
	screen_size = get_viewport_rect().size
	set_process(true)
	player = get_node("Player")
	for i in range(10):
		npcs.append(Alien.instance())
	for alien in npcs:
		add_child(alien)
		alien.setTarget(player)
	
	

func _process(delta):
	camera.position = player.position
	set_process_input(true)
	# Ship rotation based on mouse position
	mouse_position = get_local_mouse_position()
	player.steer(mouse_position)
	
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
	
func playerDied():
	for i in npcs:
		if i.getTarget() == player:
			i.setTarget(null)
			
func alienDied(alien):
	for i in npcs:
		if i == alien:
			remove_child(alien)
	
func setRepulsorBurstAt(burst_position, burst_force):
	var force_vector = calculateRepulsorForceVector(burst_position, player.position, burst_force)
	player.apply_impulse(math.zero_velocity, force_vector)
	for i in npcs:
		force_vector = calculateRepulsorForceVector(burst_position, i.position, burst_force)
		i.apply_impulse(math.zero_velocity, force_vector)
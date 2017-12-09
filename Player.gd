extends RigidBody2D

const math = preload("math.gd")

var ship_sprite
var living = true
var deg_direction
var direction = Vector2(1.0, 0.0)
var game
var magnitude
var thrust_factor = 0
var thrust_max = 30
var unit_vector

func _ready():
	game = get_node("/root/Root/Game")
	ship_sprite = get_node("Ship")

func _process(delta):
	# Thrust control
	if Input.is_mouse_button_pressed(BUTTON_LEFT) && thrust_factor < thrust_max:
		thrust_factor += 1
	else:
		thrust_factor *= .1
	if living:
		set_applied_force(unit_vector * thrust_factor)
	else:
		set_linear_velocity(math.zero_velocity)

func _input(event):
	if !living:
		pass
	if Input.is_action_just_pressed("fire_repulsor"):
		fireRepulsor()

func fireRepulsor():
	game.setRepulsorBurstAt(self.position, 50000)

func killme():
	set_applied_force(math.zero_velocity)
	set_applied_torque(0)
	set_linear_velocity(math.zero_velocity)
	ship_sprite.hide()
	living = false
	game.playerDied()
	get_node("Explosion").emitting = true
	
func steer(mouse_position):
	if !living:
		pass
	else:
		direction[0] = position[0] - mouse_position[0] 
		direction[1] = position[1] - mouse_position[1] 
		magnitude = sqrt(pow(direction[0], 2) + pow(direction[1], 2))
		unit_vector = -(direction / magnitude)
		deg_direction = -rad2deg(atan2(direction[0], direction[1]))
		rotation_degrees = deg_direction
	
func _on_Player_body_entered( body ):
	if "deadly" in body:
		var bodies = get_colliding_bodies()
		killme()
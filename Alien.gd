extends RigidBody2D

var delta_vector = Vector2(0.0, 0.0)
var linear_velocity_magnitude
var repulsor = false
var repulsor_charge = 0
var repulsor_charge_ready_time = 2
var repulsor_max_force = 50000
var repulsor_range = 50
var target
var thrust_factor = 30
var unit_linear_velocity = Vector2(0.0, 0.0)
var unit_vector_to_target = Vector2(0.0, 0.0)
var vector_to_target = Vector2(0.0, 0.0)

var sprite
var thrust_line
var velocity_line

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	repulsor_charge += delta
	if (readyToFire()):
		fireRepulsor()		
	sprite = get_node("Sprite")
	if target != null:
		moveToTarget()
		rotateTowardTarget()
		
func activateRepulsor():
	repulsor = true

func _calculateDistanceToTarget():
	var distance = repulsor_range + 10
	var distance_vector = self.position - target.position
	distance = sqrt(pow(distance_vector[0], 2) + pow(distance_vector[1], 2))
	return distance

func calculateUnitVector(vector):
	var unit_vector
	var magnitude = calculateVectorMagnitude(vector)
	if (magnitude > 0):
		unit_vector = -(vector / magnitude)
	else:
		unit_vector = vector
	return unit_vector

func calculateVectorMagnitude(vector):
	var magnitude = sqrt(pow(vector[0], 2) + pow(vector[1], 2))
	return magnitude
	
func fireRepulsor():
	repulsor_charge = 0
	var game = get_node("/root/Root/Game")
	game.setRepulsorBurstAt(self.position, repulsor_max_force)

func killme():
	print("Alien died")

func moveToTarget():
	vector_to_target = self.position - target.position
	unit_vector_to_target = calculateUnitVector(vector_to_target)
	unit_linear_velocity = calculateUnitVector(self.linear_velocity)
	linear_velocity_magnitude = calculateVectorMagnitude(self.linear_velocity)
	if linear_velocity_magnitude == 0:
		delta_vector = unit_vector_to_target
	elif linear_velocity_magnitude < 100:
		delta_vector = thrust_factor * (unit_vector_to_target - unit_linear_velocity)
	else:
		delta_vector = Vector2(0, 0)
	self.set_applied_force(delta_vector)

func rotateTowardTarget():
	var deg_direction = 180-rad2deg(atan2(unit_vector_to_target[0], unit_vector_to_target[1]))
	sprite.rotation_degrees = deg_direction

func setTarget(node):
	target = node
	
func readyToFire():
	return (target
	&& repulsor_charge >= repulsor_charge_ready_time
	&& _calculateDistanceToTarget() <= repulsor_range)
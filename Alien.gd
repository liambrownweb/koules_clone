extends RigidBody2D

var delta_vector = Vector2(0.0, 0.0)
var linear_velocity_magnitude
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
	sprite = get_node("Sprite")
	if target != null:
		moveToTarget()
		rotateTowardTarget()

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
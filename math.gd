extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
static func calculateUnitVector(vector):
	var unit_vector
	var magnitude = calculateVectorMagnitude(vector)
	if (magnitude > 0):
		unit_vector = -(vector / magnitude)
	else:
		unit_vector = vector
	return unit_vector

static func calculateVectorMagnitude(vector):
	var magnitude = sqrt(pow(vector[0], 2) + pow(vector[1], 2))
	return magnitude

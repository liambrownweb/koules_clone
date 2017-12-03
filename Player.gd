extends RigidBody2D

# class member variables go here, for example:
var ship_sprite

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ship_sprite = get_node("Ship")

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		pass

func callme():
	print ("You called?")
	
func killme():
	print ("I died!")
	ship_sprite.hide()
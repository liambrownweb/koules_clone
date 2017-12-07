extends RigidBody2D

var ship_sprite

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ship_sprite = get_node("Ship")

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE && event.pressed:
			fireRepulsor()


func callme():
	print ("You called?")

func fireRepulsor():
	var game = get_node("/root/Root/Game")
	game.setRepulsorBurstAt(self.position, 10000)

	
func killme():
	print ("I died!")
	ship_sprite.hide()
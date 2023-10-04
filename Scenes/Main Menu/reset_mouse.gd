extends Control
var normal_mouse_pointer = load("res://Graphics/HUD/mouse_pointer_normal.png")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_custom_mouse_cursor(normal_mouse_pointer)
	global_data.save_player_data()
	pass

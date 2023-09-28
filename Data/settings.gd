extends Node

#CHECKBOXES AND SLIDERS

var first_person_mouse_control: bool
var acceleration_camera_shake: bool
var third_person_camera_offset: bool
var third_person_sensitivity: float
var first_person_headlook_sensitivity: int

#MISC 

var pause_key: Array
var fa_key: Array
var first_third_person_key: Array
var first_person_headlook_key: Array
var boost_key: Array

#MOVEMENT

var accelerate_forward_key: Array
var accelerate_backward_key: Array
var pitch_up_key: Array
var pitch_down_key: Array
var yaw_left_key: Array
var yaw_right_key: Array
var roll_left_key: Array
var roll_right_key: Array
var move_up_key: Array
var move_down_key: Array
var move_left_key: Array
var move_right_key: Array

func save_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	file.store_var(first_person_mouse_control)
	file.store_var(acceleration_camera_shake)
	file.store_var(third_person_camera_offset)
	file.store_var(third_person_sensitivity)
	file.store_var(first_person_headlook_sensitivity)
	
	var keybindings = [pause_key, fa_key, first_third_person_key, first_person_headlook_key, boost_key, accelerate_forward_key, accelerate_backward_key, pitch_up_key, pitch_down_key, yaw_left_key, yaw_right_key, roll_left_key, roll_right_key, move_up_key, move_down_key, move_left_key, move_right_key]
	for keybind in keybindings:
		file.store_var(keybind)
	
	file.close()
	
	pass

func load_settings():
	if FileAccess.file_exists("user://settings.save"):
		var file = FileAccess.open("user://settings.save", FileAccess.READ)
		first_person_mouse_control = file.get_var(true)
		acceleration_camera_shake = file.get_var(true)
		third_person_camera_offset = file.get_var(true)
		third_person_sensitivity = file.get_var(true)
		first_person_headlook_sensitivity = file.get_var(true)
		
		pause_key = file.get_var(true)
		fa_key = file.get_var(true)
		first_third_person_key = file.get_var(true)
		first_person_headlook_key = file.get_var(true)
		boost_key = file.get_var(true)
		
		accelerate_forward_key = file.get_var(true)
		accelerate_backward_key = file.get_var(true)
		pitch_up_key = file.get_var(true)
		pitch_down_key = file.get_var(true)
		yaw_left_key = file.get_var(true)
		yaw_right_key = file.get_var(true)
		roll_left_key = file.get_var(true)
		roll_right_key = file.get_var(true)
		move_up_key = file.get_var(true)
		move_down_key = file.get_var(true)
		move_left_key = file.get_var(true)
		move_right_key = file.get_var(true)
		
		file.close()
		
		sync_keybindings()
		
	else:
		reset_settings()
	pass

func reset_settings():
	first_person_mouse_control = false
	acceleration_camera_shake = true
	third_person_camera_offset = false
	third_person_sensitivity = 0.1
	first_person_headlook_sensitivity = 1200
	
	pause_key = ["pause", KEY_ESCAPE]
	fa_key = ["fa_toggle", KEY_QUOTELEFT]
	first_third_person_key = ["first_person_toggle", KEY_SHIFT]
	first_person_headlook_key = ["enable_first_person_headlook", KEY_COMMA]
	boost_key = ["boost", KEY_SPACE]
	
	accelerate_forward_key = ["accelerate_forward", KEY_R]
	accelerate_backward_key = ["accelerate_backward", KEY_F]
	pitch_up_key = ["pitch_up", KEY_W]
	pitch_down_key = ["pitch_down", KEY_S]
	yaw_left_key = ["yaw_left", KEY_A]
	yaw_right_key = ["yaw_right", KEY_D]
	roll_left_key = ["roll_left", KEY_Q]
	roll_right_key = ["roll_right", KEY_E]
	move_up_key = ["move_up", KEY_UP]
	move_down_key = ["move_down", KEY_DOWN]
	move_left_key = ["move_left", KEY_LEFT]
	move_right_key = ["move_right", KEY_RIGHT]
	
	sync_keybindings()
	
	save_settings()
	
	pass

func sync_keybindings():
	var keybindings = [pause_key, fa_key, first_third_person_key, first_person_headlook_key, boost_key, accelerate_forward_key, accelerate_backward_key, pitch_up_key, pitch_down_key, yaw_left_key, yaw_right_key, roll_left_key, roll_right_key, move_up_key, move_down_key, move_left_key, move_right_key]
	
	for keybind in keybindings:
		var event = InputEventKey.new()
		event.keycode = keybind.back()
		event.pressed = true
		
		if not InputMap.action_get_events(keybind.front()).is_empty():
			InputMap.action_erase_event(keybind.front(), InputMap.action_get_events(keybind.front())[0])
		InputMap.action_add_event(keybind.front(), event)
	pass

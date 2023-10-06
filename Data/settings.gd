extends Node

var restore_defaults_type: String

#CHECKBOXES AND SLIDERS

var first_person_mouse_control: bool
var acceleration_camera_shake: bool
var third_person_camera_offset: bool
var third_person_sensitivity: float
var first_person_headlook_sensitivity: int
var mouse_movement_sensitivity: float
var mouse_movement_deadzone: float
var sfx_volume: float
var sfx_mute: bool

#MISC 

var third_person_rotate_camera_key
var third_person_zoom_key

var pause_key: Array
var fa_key: Array
var first_third_person_key: Array
var first_person_headlook_key: Array
var boost_key: Array
var spacebrake_key: Array

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
	var file = FileAccess.open("user://cosmic_time_trials_settings.save", FileAccess.WRITE)
	file.store_var(first_person_mouse_control)
	file.store_var(acceleration_camera_shake)
	file.store_var(third_person_camera_offset)
	file.store_var(third_person_sensitivity)
	file.store_var(first_person_headlook_sensitivity)
	file.store_var(mouse_movement_sensitivity)
	file.store_var(mouse_movement_deadzone)
	file.store_var(sfx_volume)
	file.store_var(sfx_mute)
	
	file.store_var(third_person_rotate_camera_key)
	file.store_var(third_person_zoom_key)
	var keybindings = [pause_key, fa_key, first_third_person_key, first_person_headlook_key, boost_key, spacebrake_key, accelerate_forward_key, accelerate_backward_key, pitch_up_key, pitch_down_key, yaw_left_key, yaw_right_key, roll_left_key, roll_right_key, move_up_key, move_down_key, move_left_key, move_right_key]
	for keybind in keybindings:
		file.store_var(keybind)
	
	file.close()
	
	pass

func load_settings():
	if FileAccess.file_exists("user://cosmic_time_trials_settings.save"):
		var file = FileAccess.open("user://cosmic_time_trials_settings.save", FileAccess.READ)
		first_person_mouse_control = file.get_var(true)
		acceleration_camera_shake = file.get_var(true)
		third_person_camera_offset = file.get_var(true)
		third_person_sensitivity = file.get_var(true)
		first_person_headlook_sensitivity = file.get_var(true)
		mouse_movement_sensitivity = file.get_var(true)
		mouse_movement_deadzone = file.get_var(true)
		sfx_volume = file.get_var(true)
		sfx_mute = file.get_var(true)
		
		third_person_rotate_camera_key = file.get_var(true)
		third_person_zoom_key = file.get_var(true)
		pause_key = file.get_var(true)
		fa_key = file.get_var(true)
		first_third_person_key = file.get_var(true)
		first_person_headlook_key = file.get_var(true)
		boost_key = file.get_var(true)
		spacebrake_key = file.get_var(true)
		
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
	match restore_defaults_type:
		"keyboard_mouse":
			reset_to_keymap_one()
		"keyboard":
			reset_to_keymap_two()
		_:
			reset_to_keymap_one()
	
	sync_keybindings()
	
	save_settings()
	
	pass

func reset_to_keymap_one():
	first_person_mouse_control = true
	acceleration_camera_shake = true
	third_person_camera_offset = true
	third_person_sensitivity = 0.1
	first_person_headlook_sensitivity = 1200
	mouse_movement_deadzone = 1.0
	mouse_movement_sensitivity = 10.0
	sfx_volume = 1.0
	sfx_mute = false
	
	third_person_rotate_camera_key = MOUSE_BUTTON_RIGHT
	third_person_zoom_key = MOUSE_BUTTON_MIDDLE
	pause_key = ["pause", KEY_ESCAPE, "key"]
	fa_key = ["fa_toggle", KEY_Z, "key"]
	first_third_person_key = ["first_person_toggle", KEY_QUOTELEFT, "key"]
	first_person_headlook_key = ["enable_first_person_headlook", KEY_TAB, "key"]
	boost_key = ["boost", KEY_SPACE, "key"]
	spacebrake_key = ["space_brake", KEY_X, "key"]
	
	accelerate_forward_key = ["accelerate_forward", KEY_SHIFT, "key"]
	accelerate_backward_key = ["accelerate_backward", KEY_CTRL, "key"]
	pitch_up_key = ["pitch_up", KEY_UP, "key"]
	pitch_down_key = ["pitch_down", KEY_DOWN, "key"]
	yaw_left_key = ["yaw_left", KEY_LEFT, "key"]
	yaw_right_key = ["yaw_right", KEY_RIGHT, "key"]
	roll_left_key = ["roll_left", KEY_Q, "key"]
	roll_right_key = ["roll_right", KEY_E, "key"]
	move_up_key = ["move_up", KEY_W, "key"]
	move_down_key = ["move_down", KEY_S, "key"]
	move_left_key = ["move_left", KEY_A, "key"]
	move_right_key = ["move_right", KEY_D, "key"]
	pass

func reset_to_keymap_two():
	first_person_mouse_control = false
	acceleration_camera_shake = true
	third_person_camera_offset = true
	third_person_sensitivity = 0.1
	first_person_headlook_sensitivity = 1200
	mouse_movement_deadzone = 1.0
	mouse_movement_sensitivity = 10.0
	sfx_volume = 1.0
	sfx_mute = false
	
	third_person_rotate_camera_key = MOUSE_BUTTON_RIGHT
	third_person_zoom_key = MOUSE_BUTTON_MIDDLE
	pause_key = ["pause", KEY_ESCAPE, "key"]
	fa_key = ["fa_toggle", KEY_QUOTELEFT, "key"]
	first_third_person_key = ["first_person_toggle", KEY_SHIFT, "key"]
	first_person_headlook_key = ["enable_first_person_headlook", KEY_TAB, "key"]
	boost_key = ["boost", KEY_SPACE, "key"]
	spacebrake_key = ["space_brake", KEY_X, "key"]
	
	accelerate_forward_key = ["accelerate_forward", KEY_R, "key"]
	accelerate_backward_key = ["accelerate_backward", KEY_F, "key"]
	pitch_up_key = ["pitch_up", KEY_W, "key"]
	pitch_down_key = ["pitch_down", KEY_S, "key"]
	yaw_left_key = ["yaw_left", KEY_A, "key"]
	yaw_right_key = ["yaw_right", KEY_D, "key"]
	roll_left_key = ["roll_left", KEY_Q, "key"]
	roll_right_key = ["roll_right", KEY_E, "key"]
	move_up_key = ["move_up", KEY_UP, "key"]
	move_down_key = ["move_down", KEY_DOWN, "key"]
	move_left_key = ["move_left", KEY_LEFT, "key"]
	move_right_key = ["move_right", KEY_RIGHT, "key"]
	pass

func sync_keybindings():
	var keybindings = [pause_key, fa_key, first_third_person_key, first_person_headlook_key, boost_key, spacebrake_key, accelerate_forward_key, accelerate_backward_key, pitch_up_key, pitch_down_key, yaw_left_key, yaw_right_key, roll_left_key, roll_right_key, move_up_key, move_down_key, move_left_key, move_right_key]
	
	for keybind in keybindings:
		var event
		
		match keybind[2]:
			"key":
				event = InputEventKey.new()
				event.keycode = keybind[1]
				event.pressed = true
			"joy":
				event = InputEventJoypadButton.new()
				event.button_index = keybind[1]
				event.pressed = true
			"joy_motion":
				event = InputEventJoypadMotion.new()
				event.axis = keybind[1]
				event.pressed = true
		
		if not InputMap.action_get_events(keybind[0]).is_empty():
			InputMap.action_erase_event(keybind[0], InputMap.action_get_events(keybind[0])[0])
		InputMap.action_add_event(keybind[0], event)
	pass

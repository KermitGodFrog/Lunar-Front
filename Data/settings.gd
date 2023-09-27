extends Node

var first_person_mouse_control: bool
var acceleration_camera_shake: bool
var third_person_sensitivity: float
var first_person_headlook_sensitivity: int

var pause_key: Array
var fa_key: Array
var camera_offset_key: Array

@onready var keybindings = [pause_key, fa_key, camera_offset_key]

func save_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	file.store_var(first_person_mouse_control)
	file.store_var(acceleration_camera_shake)
	file.store_var(third_person_sensitivity)
	file.store_var(first_person_headlook_sensitivity)
	
	file.store_var(pause_key)
	file.store_var(fa_key)
	file.store_var(camera_offset_key)
	
	file.close()
	pass

func load_settings():
	if FileAccess.file_exists("user://settings.save"):
		var file = FileAccess.open("user://settings.save", FileAccess.READ)
		first_person_mouse_control = file.get_var(true)
		acceleration_camera_shake = file.get_var(true)
		third_person_sensitivity = file.get_var(true)
		first_person_headlook_sensitivity = file.get_var(true)
		
		pause_key = file.get_var(true)
		fa_key = file.get_var(true)
		camera_offset_key = file.get_var(true)
		
		file.close()
		
		if not self.is_node_ready():
			await self.ready
		
		sync_keybindings()
		
	else:
		reset_settings()
	pass

func reset_settings():
	first_person_mouse_control = false
	acceleration_camera_shake = true
	third_person_sensitivity = 0.1
	first_person_headlook_sensitivity = 1200
	pause_key = ["pause", KEY_ESCAPE]
	fa_key = ["fa_toggle", KEY_QUOTELEFT]
	camera_offset_key = ["camera_offset_toggle", KEY_X]
	
	if not self.is_node_ready():
		await self.ready
	
	sync_keybindings()
	
	save_settings()
	pass

func sync_keybindings():
	for keybind in keybindings:
		var event = InputEventKey.new()
		event.keycode = keybind[1]
		event.pressed = true
		
		if not InputMap.action_get_events(keybind[0]).is_empty():
			InputMap.action_erase_event(keybind[0], InputMap.action_get_events(keybind[0])[0])
		InputMap.action_add_event(keybind[0], event)
	pass

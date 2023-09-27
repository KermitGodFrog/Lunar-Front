extends Node

var first_person_mouse_control: bool
var acceleration_camera_shake: bool
var third_person_sensitivity: float
var first_person_headlook_sensitivity: int

func save_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	file.store_var(first_person_mouse_control)
	file.store_var(acceleration_camera_shake)
	file.store_var(third_person_sensitivity)
	file.store_var(first_person_headlook_sensitivity)
	file.close()
	pass

func load_settings():
	if FileAccess.file_exists("user://settings.save"):
		var file = FileAccess.open("user://settings.save", FileAccess.READ)
		first_person_mouse_control = file.get_var(true)
		acceleration_camera_shake = file.get_var(true)
		third_person_sensitivity = file.get_var(true)
		first_person_headlook_sensitivity = file.get_var(true)
		file.close()
	else:
		reset_settings()
	pass

func reset_settings():
	first_person_mouse_control = false
	acceleration_camera_shake = true
	third_person_sensitivity = 0.1
	first_person_headlook_sensitivity = 1200
	save_settings()
	pass

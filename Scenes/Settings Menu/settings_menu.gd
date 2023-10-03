extends Control
var normal_mouse_pointer = load("res://Graphics/HUD/mouse_pointer_normal.png")
@export var restore_defaults_button_group: ButtonGroup

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_custom_mouse_cursor(normal_mouse_pointer)
	
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

func _on_save_button_pressed():
	for option in get_tree().get_nodes_in_group("bool_option"):
		var settings_variable = option.get("settings_variable")
		settings.set(settings_variable, option.button_pressed)
	
	for option in get_tree().get_nodes_in_group("slider_option"):
		var settings_variable = option.get("settings_variable")
		settings.set(settings_variable, option.value)
	
	for option in get_tree().get_nodes_in_group("keybind_option"):
		var settings_variable = option.get("settings_variable")
		if not InputMap.action_get_events(option.action_string).is_empty():
			match option.action_type:
				"key":
					settings.set(settings_variable, [option.action_string, InputMap.action_get_events(option.action_string)[0].keycode, "key"])
				"joy":
					settings.set(settings_variable, [option.action_string, InputMap.action_get_events(option.action_string)[0].button_index, "joy"])
	
	for option in get_tree().get_nodes_in_group("psuedo_mouse_keybind_option"):
		var settings_variable = option.get("settings_variable")
		settings.set(settings_variable, option.button_index)
	
	settings.save_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

func _on_restore_defaults_button_pressed():
	var pressed_button = restore_defaults_button_group.get_pressed_button()
	if pressed_button:
		settings.restore_defaults_type = pressed_button.restore_string
	settings.reset_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

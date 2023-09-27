extends Control

func _ready():
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
			settings.set(settings_variable, [option.action_string, InputMap.action_get_events(option.action_string)[0].keycode])
	
	settings.save_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

func _on_restore_defaults_button_pressed():
	settings.reset_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

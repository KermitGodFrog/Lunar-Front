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
	
	settings.save_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

func _on_restore_defaults_button_pressed():
	settings.reset_settings()
	get_tree().call_group("bool_option", "sync_settings_variable")
	get_tree().call_group("slider_option", "sync_settings_variable")
	pass

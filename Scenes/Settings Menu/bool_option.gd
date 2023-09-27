extends CheckBox

@export var settings_variable: String

func sync_settings_variable():
	set("button_pressed", settings.get(settings_variable))
	pass

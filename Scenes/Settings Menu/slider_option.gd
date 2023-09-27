extends HSlider

@export var settings_variable: String

func sync_settings_variable():
	set("value", settings.get(settings_variable))
	pass

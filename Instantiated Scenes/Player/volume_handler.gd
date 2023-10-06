extends Node

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), settings.sfx_volume)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), settings.sfx_mute)
	pass

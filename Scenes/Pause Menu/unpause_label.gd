extends Label

func _ready():
	var events = InputMap.action_get_events("pause")
	var events_string: String
	
	for event in events:
		events_string += event.as_text()
	
	set_text(str("[ PRESS ", events_string, " TO RESUME ]"))
	
	pass

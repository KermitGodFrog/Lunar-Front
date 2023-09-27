extends Label

func _ready():
	if not InputMap.action_get_events("pause").is_empty():
		var event = InputMap.action_get_events("pause")[0]
		set_text(str("[ PRESS ", OS.get_keycode_string(event.keycode), " TO RESUME ]"))
	else:
		set_text(str("[ PRESS (UNSET, GOOD LUCK HAHAHAHAHA) TO RESUME ]"))
	pass

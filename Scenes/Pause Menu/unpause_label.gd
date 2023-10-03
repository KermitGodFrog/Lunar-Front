extends Label

func _ready():
	if not InputMap.action_get_events("pause").is_empty():
		var event = InputMap.action_get_events("pause")[0]
		if event is InputEventKey:
			set_text(str("[ PRESS ", OS.get_keycode_string(event.keycode), " TO RESUME ]"))
		if event is InputEventJoypadButton:
			set_text(str("[ PRESS ", "JOY_", event.button_index, " TO RESUME ]"))
		if event is InputEventJoypadMotion:
			set_text(str("[ PRESS ", "JOY_MOTION_", event.axis, " TO RESUME ]"))
	else:
		set_text(str("[ PRESS (UNSET, GOOD LUCK HAHAHAHAHA) TO RESUME ]"))
	pass

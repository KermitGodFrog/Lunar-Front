extends Button
@export var keybindings_button_group: ButtonGroup = load("res://Scenes/Settings Menu/keybindings_button_group.tres")

@export var settings_variable: String
@export var action_string: String
var action_type: String

func _process(delta):
	if not InputMap.action_get_events(action_string).is_empty():
		var event = InputMap.action_get_events(action_string)[0]
		if event is InputEventKey:
			set_text(OS.get_keycode_string(event.keycode))
		if event is InputEventJoypadButton:
			set_text(str("JOY_", event.button_index))
		if event is InputEventJoypadMotion:
			set_text(str("JOY_MOTION_", event.axis))
	pass

func _input(event):
	if event is InputEventKey:
		if keybindings_button_group.get_pressed_button() == self:
			change_key(event)
			set("button_pressed", false)
			set("action_type", "key")
	if event is InputEventJoypadButton:
		if keybindings_button_group.get_pressed_button() == self:
			change_key(event)
			set("button_pressed", false)
			set("action_type", "joy")
	if event is InputEventJoypadMotion:
		if keybindings_button_group.get_pressed_button() == self:
			change_key(event)
			set("button_pressed", false)
			set("action_type", "joy_motion")
	pass

func change_key(key):
	if not InputMap.action_get_events(action_string).is_empty():
		InputMap.action_erase_event(action_string, InputMap.action_get_events(action_string)[0])
	InputMap.action_add_event(action_string, key)
	pass

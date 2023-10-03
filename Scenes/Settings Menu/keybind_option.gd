extends Button
@export var keybindings_button_group: ButtonGroup = load("res://Scenes/Settings Menu/keybindings_button_group.tres")

@export var settings_variable: String
@export var action_string: String
var action_type: String

func _process(delta):
	if not InputMap.action_get_events(action_string).is_empty():
		var event = InputMap.action_get_events(action_string)[0]
		set_text(OS.get_keycode_string(event.keycode))
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
	pass

func change_key(key):
	if not InputMap.action_get_events(action_string).is_empty():
		InputMap.action_erase_event(action_string, InputMap.action_get_events(action_string)[0])
	InputMap.action_add_event(action_string, key)
	pass

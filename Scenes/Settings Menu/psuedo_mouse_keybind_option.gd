extends Button
@export var keybindings_button_group: ButtonGroup = load("res://Scenes/Settings Menu/keybindings_button_group.tres")

@export var settings_variable: String

var button_index

func _ready():
	button_index = settings.get(settings_variable)
	pass

func _process(delta):
	set_text(str("MOUSE_", button_index))
	pass

func _input(event):
	if event is InputEventMouseButton:
		if keybindings_button_group.get_pressed_button() == self:
			change_button(event.button_index)
			set("button_pressed", false)
	pass

func change_button(index):
	button_index = index
	pass

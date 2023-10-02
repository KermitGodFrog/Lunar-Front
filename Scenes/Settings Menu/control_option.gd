extends Button

@export var restore_string: String
@export var button_text: String

func _ready():
	self.toggled.connect(_on_toggled)
	set_text(button_text)
	pass

func _on_toggled(is_pressed: bool):
	match is_pressed:
		true:
			set_text(str("< ", button_text))
		false:
			set_text(str(button_text))
	pass

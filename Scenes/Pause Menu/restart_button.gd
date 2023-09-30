extends Button

func _ready():
	self.pressed.connect(_on_pressed)
	pass

func _on_pressed():
	get_tree().reload_current_scene()
	pass

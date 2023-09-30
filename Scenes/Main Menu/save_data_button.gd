extends Button

func _ready():
	self.pressed.connect(_on_pressed)
	pass

func _on_pressed():
	global_data.save_player_data()
	pass

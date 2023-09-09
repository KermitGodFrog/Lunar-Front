extends Button
class_name SceneChangeButton

@export_file("*.tscn") var to_scene

func _ready():
	self.pressed.connect(_on_pressed)
	pass

func _on_pressed():
	get_tree().change_scene_to_file(to_scene)
	pass

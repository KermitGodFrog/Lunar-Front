extends SceneChangeButton

func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(to_scene)
	pass

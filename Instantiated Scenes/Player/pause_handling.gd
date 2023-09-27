extends Node

func _input(event):
	if event.is_action_pressed("pause"):
		match get_tree().paused:
			true:
				get_tree().paused = false
				$pause_menu.hide()
			false:
				get_tree().paused = true
				$pause_menu.show()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass

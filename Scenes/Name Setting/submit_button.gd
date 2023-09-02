extends Button
var profanity_list_array: PackedStringArray

@export_global_file("*.tscn") var to_scene

func _ready():
	var file = FileAccess.open("res://Data/profanity-list.txt", FileAccess.READ)
	while not file.eof_reached():
		profanity_list_array.append(file.get_line())
	pass

func _on_pressed():
	var name_edit = owner.get_tree().get_first_node_in_group("name_edit")
	var username = name_edit.text
	
	for word in profanity_list_array:
		var profanity_check = username.findn(str(word))
		if profanity_check == -1:
			continue
		else:
			print("PLAYER NAME CHANGE FAILED")
			return
	
	global_data.player_name = username
	print("PLAYER NAME CHANGE SUCCESSFUL")
	print("PLAYER NAME IS NOW: ", global_data.player_name)
	
	get_tree().change_scene_to_file(to_scene)
	
	pass


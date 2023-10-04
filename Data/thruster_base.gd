extends Node
class_name Thruster

@export_node_path("CharacterBody3D") var input_body

var axis: int
var time: float

func update_axis(incoming_axis: int):
	axis = incoming_axis
	pass

func update_time(incoming_time: float):
	time = incoming_time
	pass

func _physics_process(delta):
	for child in get_children():
		child.set_emitting(false)
	
	check_children(axis)
	if get_node(input_body).is_fa_toggle == true and get_node(input_body).is_movement == false:
		if time > 0.80:
			check_children(-1)
		if time < -0.80:
			check_children(1)
	pass

func check_children(check_axis: int):
	var thruster_sound = get_tree().get_first_node_in_group("thruster_sound")
	for child in get_children():
		if child.is_in_group("axis_" + str(check_axis)):
			child.set_emitting(true)
		else:
			child.set_emitting(false)
	pass

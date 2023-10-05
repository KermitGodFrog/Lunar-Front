extends VBoxContainer
class_name ParTimes

@export_node_path("Label") var gold_label
@export_node_path("Label") var iron_label
@export_node_path("Label") var bronze_label

func update(map_identifier: String):
	var par_times = global_data.get(str(map_identifier, "_par_times"))
	
	if par_times:
		get_node(gold_label).set_text(str(par_times[2], "s"))
		get_node(iron_label).set_text(str(par_times[1], "s"))
		get_node(bronze_label).set_text(str(par_times[0], "s"))
	
	pass

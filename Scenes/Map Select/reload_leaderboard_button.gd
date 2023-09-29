extends Button

func _on_pressed():
	pass

func force_reload_scores():
	var leaderboard_status_list = get_tree().get_first_node_in_group("leaderboard_status_list")
	if leaderboard_status_list:
		if not leaderboard_status_list.last_selected_map.is_empty():
			get_tree().call_group("leaderboard_status_list", "update", leaderboard_status_list.last_selected_map, true)
	pass

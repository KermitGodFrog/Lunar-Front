extends Area3D
class_name Checkpoint

@export var ROTATION_SPEED: int = 25
@export var CHECKPOINT_NUMBER: int

func _on_body_entered(body):
	if body is Player:
		if body.current_checkpoint:
			if body.current_checkpoint == map_data.checkpoints[CHECKPOINT_NUMBER - 1]:
				body.current_checkpoint = self
				game_data.hud_effect.rectangle_effect(Color.GREEN, 0.3)
				if CHECKPOINT_NUMBER == 0:
					
					if global_data.get_best_time_current_map() == 0:
						global_data.set_best_time_current_map(game_data.player.current_time)
						leaderboard_handling()
						
					if game_data.player.current_time < global_data.get_best_time_current_map():
						get_tree().call_group("time_decrease_label", "show_new_time", global_data.get_best_time_current_map() - game_data.player.current_time)
						global_data.set_best_time_current_map(game_data.player.current_time)
						leaderboard_handling()
						
					#RESETTING GAMEPLAY STUFF
					
					game_data.player.current_time = 0
					game_data.player.BOOST_TIME = game_data.player.BOOST_STARTING_TIME
					
					get_tree().call_group("receive_race_starting", "_on_race_start")
					get_tree().call_group("medal_status", "update_medal")
					if map_data.boost_pickups.size() > 0:
						for boost_pickup in map_data.boost_pickups:
							boost_pickup.is_used = false
					if map_data.slingshot_pickups.size() > 0:
						for slingshot_pickup in map_data.slingshot_pickups:
							slingshot_pickup.is_used = false
					
		elif CHECKPOINT_NUMBER == 0:
			body.current_checkpoint = self
			game_data.hud_effect.rectangle_effect(Color.GREEN, 0.3)
			get_tree().call_group("receive_race_starting", "_on_race_start")
			get_tree().call_group("medal_status", "update_medal")
	pass

func leaderboard_handling():
	var sw_save_score: Dictionary = await SilentWolf.Scores.save_score(global_data.player_name, global_data.get_best_time_current_map(), str(map_data.map_identifier, "_map")).sw_save_score_complete
	var score_id = sw_save_score.score_id
	global_data.player_latest_score_id = score_id
	
	var sw_scores_around = await SilentWolf.Scores.get_scores_around(score_id, 6, str(map_data.map_identifier, "_map")).sw_get_scores_around_complete
	get_tree().call_group("leaderboard_status_list", "update", sw_scores_around.scores_below)
	pass










func _physics_process(delta):
	rotation.z += deg_to_rad(ROTATION_SPEED) * delta
	
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	if next_checkpoint_one == self:
		$next_checkpoint_mesh.show()
	else:
		$next_checkpoint_mesh.hide()
	pass

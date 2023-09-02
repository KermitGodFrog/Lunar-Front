extends Area3D
class_name Checkpoint

@export var ROTATION_SPEED: int = 25
@export var CHECKPOINT_NUMBER: int

func _on_body_entered(body):
	var best_time = global_data.get_best_time_current_map()
	
	if body is Player:
		if body.current_checkpoint:
			if body.current_checkpoint == map_data.checkpoints[CHECKPOINT_NUMBER - 1]:
				body.current_checkpoint = self
				if CHECKPOINT_NUMBER == 0:
					
					if global_data.get_best_time_current_map() == 0:
						global_data.set_best_time_current_map(game_data.player.current_time)
					
					if game_data.player.current_time < global_data.get_best_time_current_map():
						get_tree().call_group("time_decrease_label", "tween_new_time", global_data.get_best_time_current_map() - game_data.player.current_time)
						global_data.set_best_time_current_map(game_data.player.current_time)
						var sw_result: Dictionary = await SilentWolf.Scores.save_score(global_data.player_name, global_data.get_best_time_current_map(), "scrapyard_map").sw_save_score_complete
						print("Score persisted successfully: " + str(sw_result.score_id))
						
					
					#RESETTING GAMEPLAY STUFF
					
					game_data.player.current_time = 0
					game_data.player.BOOST_TIME = game_data.player.BOOST_STARTING_TIME
					
					get_tree().call_group("receive_race_starting", "_on_race_start")
					
					for boost_pickup in map_data.boost_pickups:
						boost_pickup.is_used = false
					
		elif CHECKPOINT_NUMBER == 0:
			body.current_checkpoint = self
			
			get_tree().call_group("receive_race_starting", "_on_race_start")
	pass

func _physics_process(delta):
	rotation.z += deg_to_rad(ROTATION_SPEED) * delta
	
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	if next_checkpoint_one == self:
		$next_checkpoint_mesh.show()
	else:
		$next_checkpoint_mesh.hide()
	pass

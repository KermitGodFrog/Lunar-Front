extends Area3D
class_name Checkpoint

@export var CHECKPOINT_NUMBER: int

func _on_body_entered(body):
	if body is Player:
		if body.current_checkpoint:
			if body.current_checkpoint == map_data.checkpoints[CHECKPOINT_NUMBER - 1]:
				body.current_checkpoint = self
				if CHECKPOINT_NUMBER == 0:
					if game_data.player.best_time < game_data.player.current_time:
						game_data.player.best_time = game_data.player.current_time
					game_data.player.current_time = 0
					game_data.player.BOOST_TIME = game_data.player.BOOST_STARTING_TIME
		elif CHECKPOINT_NUMBER == 0:
			body.current_checkpoint = self
	pass

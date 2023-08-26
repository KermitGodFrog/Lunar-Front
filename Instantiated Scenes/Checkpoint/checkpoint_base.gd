extends Area3D
class_name Checkpoint

@export var ROTATION_SPEED: int = 25
@export var CHECKPOINT_NUMBER: int

func _on_body_entered(body):
	if body is Player:
		if body.current_checkpoint:
			if body.current_checkpoint == map_data.checkpoints[CHECKPOINT_NUMBER - 1]:
				body.current_checkpoint = self
				if CHECKPOINT_NUMBER == 0:
					
					if game_data.player.best_time == 0:
						game_data.player.best_time = game_data.player.current_time
					if game_data.player.current_time < game_data.player.best_time:
						game_data.player.best_time = game_data.player.current_time
					
					game_data.player.current_time = 0
					game_data.player.BOOST_TIME = game_data.player.BOOST_STARTING_TIME
					
					for boost_pickup in map_data.boost_pickups:
						boost_pickup.is_used = false
					
		elif CHECKPOINT_NUMBER == 0:
			body.current_checkpoint = self
	pass

func _physics_process(delta):
	rotation.z += deg_to_rad(ROTATION_SPEED) * delta
	
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	if next_checkpoint_one == self:
		$next_checkpoint_mesh.show()
	else:
		$next_checkpoint_mesh.hide()
	pass

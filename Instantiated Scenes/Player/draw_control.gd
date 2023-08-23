extends Control

func _physics_process(delta):
	queue_redraw()
	pass

func _draw():
	var next_checkpoint_one: Checkpoint
	var next_checkpoint_two: Checkpoint
	
	if game_data.player.current_checkpoint:
		if game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 1 <= map_data.checkpoints.size() - 1:
			next_checkpoint_one = map_data.checkpoints[game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 1]
		elif game_data.player.current_checkpoint == map_data.checkpoints.back():
			next_checkpoint_one = map_data.checkpoints[0]
		
		if game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 2 <= map_data.checkpoints.size() - 1:
			next_checkpoint_two = map_data.checkpoints[game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 2]
		elif game_data.player.current_checkpoint == map_data.checkpoints.back():
			next_checkpoint_two = map_data.checkpoints[1]
		elif game_data.player.current_checkpoint == map_data.checkpoints[map_data.checkpoints.size() - 2]:
			next_checkpoint_two = map_data.checkpoints[0]
	else:
		next_checkpoint_one = map_data.checkpoints[0]
		next_checkpoint_two = map_data.checkpoints[1]
	
	if next_checkpoint_one:
		draw_line(get_parent().unproject_position(game_data.player.global_transform.origin), get_parent().unproject_position(next_checkpoint_one.global_transform.origin), Color.BLUE, 1)
	if next_checkpoint_one and next_checkpoint_two:
		draw_line(get_parent().unproject_position(next_checkpoint_one.global_transform.origin), get_parent().unproject_position(next_checkpoint_two.global_transform.origin), Color.PURPLE, 1)
	pass

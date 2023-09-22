extends Node

var map_identifier: String
var checkpoints: Array
var boost_pickups: Array
var slingshot_pickups: Array

func get_next_checkpoint_one():
	var next_checkpoint_one: Checkpoint
	
	if game_data.player.current_checkpoint:
		if game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 1 <= checkpoints.size() - 1:
			next_checkpoint_one = checkpoints[game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 1]
		elif game_data.player.current_checkpoint == checkpoints.back():
			next_checkpoint_one = checkpoints[0]
	else:
		next_checkpoint_one = checkpoints[0]
	
	return next_checkpoint_one

func get_next_checkpoint_two():
	var next_checkpoint_two: Checkpoint
	
	if game_data.player.current_checkpoint:
		if game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 2 <= checkpoints.size() - 1:
			next_checkpoint_two = checkpoints[game_data.player.current_checkpoint.CHECKPOINT_NUMBER + 2]
		elif game_data.player.current_checkpoint == checkpoints.back():
			next_checkpoint_two = checkpoints[1]
		elif game_data.player.current_checkpoint == checkpoints[checkpoints.size() - 2]:
			next_checkpoint_two = checkpoints[0]
	else:
		next_checkpoint_two = checkpoints[1]
	
	return next_checkpoint_two

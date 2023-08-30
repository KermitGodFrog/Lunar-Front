extends Control
var movement_dir_png = preload("res://Graphics/HUD/movement_dir_png.png")
var direction_png = preload("res://Graphics/HUD/direction_png.png")

func _physics_process(delta):
	queue_redraw()
	pass

func _draw():
	var camera_offset = get_tree().get_first_node_in_group("camera_offset")
	
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	var next_checkpoint_two = map_data.get_next_checkpoint_two()
	
	#VELOCITY DIRECTION DRAWING
	
	var unprojected_position = get_parent().unproject_position(game_data.player.global_transform.origin + game_data.player.velocity)
	var velocity_direction = camera_offset.global_transform.origin - Vector3(game_data.player.global_transform.origin + game_data.player.velocity)
	var velocity_dot = velocity_direction.normalized().dot(-camera_offset.global_transform.basis.z)
	
	if velocity_dot > 0:
		draw_texture(movement_dir_png, Vector2(unprojected_position.x - 8, unprojected_position.y - 8))
	
	#TOTAL DIRECTION DRAWING
	
	var total_direction_position = get_parent().unproject_position(game_data.player.global_transform.origin + -game_data.player.transform.basis.z * 1000)
	draw_texture(direction_png, Vector2(total_direction_position.x - 8, total_direction_position.y - 8))
	
	#NEXT CHECKPOINT ONE DRAWING
	
	if next_checkpoint_one:
		var checkpoint_one_direction = camera_offset.global_transform.origin - next_checkpoint_one.global_transform.origin
		var checkpoint_one_dot = checkpoint_one_direction.normalized().dot(-camera_offset.global_transform.basis.z)
		
		if checkpoint_one_dot > 0:
			draw_line(get_parent().unproject_position(game_data.player.global_transform.origin), get_parent().unproject_position(next_checkpoint_one.global_transform.origin), Color.LIGHT_GREEN, 1)
	
	#NEXT CHECKPOINT TWO DRAWING
	
	if next_checkpoint_one and next_checkpoint_two:
		var checkpoint_two_direction = camera_offset.global_transform.origin - next_checkpoint_two.global_transform.origin
		var checkpoint_two_dot = checkpoint_two_direction.normalized().dot(-camera_offset.global_transform.basis.z)
		
		if checkpoint_two_dot > 0:
			draw_line(get_parent().unproject_position(next_checkpoint_one.global_transform.origin), get_parent().unproject_position(next_checkpoint_two.global_transform.origin), Color.GREEN, 1)
	pass

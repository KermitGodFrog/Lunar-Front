extends Control
var movement_dir_png = preload("res://Graphics/HUD/movement_dir_png.png")
var direction_png = preload("res://Graphics/HUD/direction_png.png")
var checkpoint_marker_png = preload("res://Graphics/HUD/checkpoint_marker_png.png")
var checkpoint_marker_flipped_png = preload("res://Graphics/HUD/checkpoint_marker_png_flipped.png")
var arrow_png = preload("res://Graphics/arrow_png.png")
var slingshot_png = preload("res://Graphics/instantanious_boost_png.png")

var pointer_margin = 10

func _physics_process(delta):
	queue_redraw()
	pass

func _draw():
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	var next_checkpoint_two = map_data.get_next_checkpoint_two()
	var viewport_midpoint = get_viewport_rect().size / 2
	
	#SLINGSHOT DIRECTION DRAWING
	
	var closest_slingshot = game_data.get_closest_body(get_tree().get_nodes_in_group("slingshot_pickup"), game_data.player.global_transform.origin)
	if closest_slingshot:
		if not closest_slingshot.is_used:
			if closest_slingshot.global_transform.origin.distance_to(game_data.player.global_transform.origin) < 900:
				if get_viewport().get_camera_3d().is_position_behind(closest_slingshot.global_transform.origin):
					var slingshot_direction_position
					slingshot_direction_position = viewport_midpoint + -viewport_midpoint.direction_to(get_parent().unproject_position(closest_slingshot.global_transform.origin)) * get_viewport_rect().size.y / 4
					draw_texture(slingshot_png, Vector2(slingshot_direction_position.x - 16, slingshot_direction_position.y - 16))
	
	#VELOCITY DIRECTION DRAWING
	
	var velocity_unprojected_position = get_parent().unproject_position(game_data.player.global_transform.origin + game_data.player.velocity)
	#var velocity_direction = camera_offset.global_transform.origin - Vector3(game_data.player.global_transform.origin + game_data.player.velocity)
	#var velocity_dot = velocity_direction.normalized().dot(-camera_offset.global_transform.basis.z)
	#if velocity_dot > 0:
	
	if not get_viewport().get_camera_3d().is_position_behind(game_data.player.global_transform.origin + game_data.player.velocity):
		draw_texture(movement_dir_png, Vector2(velocity_unprojected_position.x - 8, velocity_unprojected_position.y - 8))
	
	#TOTAL DIRECTION DRAWING
	
	var total_direction_position = get_parent().unproject_position(game_data.player.global_transform.origin + -game_data.player.transform.basis.z * 1000)
	draw_texture(direction_png, Vector2(total_direction_position.x - 8, total_direction_position.y - 8))
	
	#NEXT CHECKPOINT ONE DRAWING
	
	if next_checkpoint_one:
		var checkpoint_marker_position: Vector2
		#var checkpoint_one_direction = camera_offset.global_transform.origin - next_checkpoint_one.global_transform.origin
		#var checkpoint_one_dot = checkpoint_one_direction.normalized().dot(-camera_offset.global_transform.basis.z)
		#if checkpoint_one_dot > 0:
		
		if not get_viewport().get_camera_3d().is_position_behind(next_checkpoint_one.global_transform.origin):
			draw_line(get_parent().unproject_position(game_data.player.global_transform.origin), get_parent().unproject_position(next_checkpoint_one.global_transform.origin), Color.LIGHT_GREEN, 1)
			checkpoint_marker_position = get_parent().unproject_position(next_checkpoint_one.global_transform.origin)
		else:
			checkpoint_marker_position = viewport_midpoint + -viewport_midpoint.direction_to(get_parent().unproject_position(next_checkpoint_one.global_transform.origin)) * get_viewport_rect().size.y / 4
		draw_texture(checkpoint_marker_flipped_png, Vector2(checkpoint_marker_position.x - 8, checkpoint_marker_position.y - 8))
	
	#NEXT CHECKPOINT TWO DRAWING
	
	if next_checkpoint_one and next_checkpoint_two:
		#var checkpoint_one_direction = camera_offset.global_transform.origin - next_checkpoint_one.global_transform.origin
		#var checkpoint_one_dot = checkpoint_one_direction.normalized().dot(-camera_offset.global_transform.basis.z)
		
		#var checkpoint_two_direction = camera_offset.global_transform.origin - next_checkpoint_two.global_transform.origin
		#var checkpoint_two_dot = checkpoint_two_direction.normalized().dot(-camera_offset.global_transform.basis.z)
		#if checkpoint_one_dot > 0 and checkpoint_two_dot > 0:
		
		if not get_viewport().get_camera_3d().is_position_behind(next_checkpoint_one.global_transform.origin) and not get_viewport().get_camera_3d().is_position_behind(next_checkpoint_two.global_transform.origin):
			draw_line(get_parent().unproject_position(next_checkpoint_one.global_transform.origin), get_parent().unproject_position(next_checkpoint_two.global_transform.origin), Color.GREEN, 1)
	pass

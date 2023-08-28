extends TextureRect
var collision_warning_png = preload("res://Graphics/HUD/collision_warning_png.png")
var collision_fine_png = preload("res://Graphics/HUD/collision_fine_png.png")

func _physics_process(delta):
	var space_state = game_data.base_node.get_world_3d().direct_space_state
	
	var ray_origin = game_data.player.global_transform.origin
	var ray_end = game_data.player.global_transform.origin + game_data.player.velocity * 500
	var exceptions = [game_data.player]
	
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 1, exceptions))
	
	if intersection:
		set_texture(collision_warning_png)
	else:
		set_texture(collision_fine_png)
	pass

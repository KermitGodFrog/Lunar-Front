extends TurretBase

func commence_firing():
	game_data.spawn_pd_round(get_parent(), PROJECTILE_SPEED, 1, get_node(spawn_marker).global_transform)
	print("spawn marker ", get_node(spawn_marker).global_transform.origin)
	pass

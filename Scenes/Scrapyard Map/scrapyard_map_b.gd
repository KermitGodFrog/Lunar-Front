extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "scrapyard_b"
	map_data.checkpoints = [$checkpoint, $checkpoint2, $checkpoint3, $checkpoint4]
	map_data.boost_pickups = []
	map_data.slingshot_pickups = []
	pass

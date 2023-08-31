extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "scrapyard_map"
	map_data.checkpoints = [$checkpoint1, $checkpoint2]
	map_data.boost_pickups = []
	pass

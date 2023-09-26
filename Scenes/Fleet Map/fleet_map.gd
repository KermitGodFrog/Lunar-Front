extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "fleet_map"
	map_data.checkpoints = []
	map_data.boost_pickups = []
	pass

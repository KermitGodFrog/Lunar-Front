extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "trade_route"
	map_data.checkpoints = [$checkpoint, $station/small_ring_one/mesh/checkpoint, $station/small_ring_two/mesh/checkpoint, $station/ring_two/mesh/checkpoint, $checkpoint2, $checkpoint3, $station/ring_two/mesh/checkpoint2, $checkpoint4, $checkpoint5, $checkpoint6, $checkpoint7]
	map_data.boost_pickups = []
	map_data.slingshot_pickups = []
	pass

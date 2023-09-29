extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "asteroid_refinery"
	map_data.checkpoints = [$checkpoint, $checkpoint2, $checkpoint3, $checkpoint4, $checkpoint5, $checkpoint6, $checkpoint7]
	map_data.boost_pickups = [$boost_pickup1, $boost_pickup2]
	map_data.slingshot_pickups = [$slingshot_pickup]
	pass

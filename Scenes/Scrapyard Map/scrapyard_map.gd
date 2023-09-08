extends Node3D

func _ready():
	game_data.base_node = self
	map_data.map_identifier = "scrapyard"
	map_data.checkpoints = [$checkpoint1, $checkpoint2, $checkpoint3, $checkpoint4, $checkpoint5, $checkpoint6, $checkpoint7, $checkpoint8, $checkpoint9]
	map_data.boost_pickups = [$boost_pickup]
	map_data.slingshot_pickups = [$slingshot_pickup]
	pass

extends Node3D

func _ready():
	game_data.base_node = self
	map_data.checkpoints = [$checkpoint, $checkpoint2, $checkpoint3, $checkpoint4, $checkpoint5]
	pass

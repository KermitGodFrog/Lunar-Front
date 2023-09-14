extends TextureRect

@export var map: String

func _ready():
	var medal_texture = global_data.get_medal_from_map(map)
	if medal_texture:
		set_texture(medal_texture)
	pass

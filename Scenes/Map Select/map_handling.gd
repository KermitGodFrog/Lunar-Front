extends HBoxContainer

@export_file("*.tscn") var to_scene
@export var requirements: Array
@export_node_path("Button") var scene_change_button
@export_node_path("Label") var requirements_label
@export_node_path("TextureRect") var required_medal_texture_rect

func _ready():
	get_node(scene_change_button).pressed.connect(_on_pressed)
	check_requirements()
	pass

func check_requirements():
	if not requirements.is_empty():
		var map_identifier = requirements.front()
		var required_medal_int = requirements.back()
		var current_medal_int = global_data.get_medal_int_from_map(map_identifier)
		
		
		if current_medal_int == required_medal_int:
			return
		elif current_medal_int > required_medal_int:
			return
		else:
			var medal_texture: Texture
			match required_medal_int:
				1:
					medal_texture = global_data.bronze_medal
				2:
					medal_texture = global_data.iron_medal
				3:
					medal_texture = global_data.gold_medal
				_:
					medal_texture = global_data.no_medal
			
			get_node(scene_change_button).set_disabled(true)
			get_node(required_medal_texture_rect).set_texture(medal_texture)
			get_node(requirements_label).set_text(map_identifier)
	pass

func _on_pressed():
	get_tree().change_scene_to_file(to_scene)
	pass

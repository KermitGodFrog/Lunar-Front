extends Control
var movement_dir_png = preload("res://Instantiated Scenes/Player/movement_dir_png.png")

func _physics_process(delta):
	queue_redraw()
	pass

func _draw():
	var next_checkpoint_one = map_data.get_next_checkpoint_one()
	var next_checkpoint_two = map_data.get_next_checkpoint_two()
	
	draw_texture(movement_dir_png, get_parent().unproject_position(game_data.player.global_transform.origin + game_data.player.velocity))
	
	if next_checkpoint_one:
		draw_line(get_parent().unproject_position(game_data.player.global_transform.origin), get_parent().unproject_position(next_checkpoint_one.global_transform.origin), Color.LIGHT_GREEN, 1)
	if next_checkpoint_one and next_checkpoint_two:
		draw_line(get_parent().unproject_position(next_checkpoint_one.global_transform.origin), get_parent().unproject_position(next_checkpoint_two.global_transform.origin), Color.GREEN, 1)
	pass

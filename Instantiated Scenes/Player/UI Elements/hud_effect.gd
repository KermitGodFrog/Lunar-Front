extends CanvasLayer

var tween

func _ready():
	game_data.hud_effect = self
	pass

func circle_effect(initial_color: Color, time: float):
	$ring_effect_grouping_node.hide()
	$rectangle_effect.hide()
	
	$circle_effect.set_flip_h(bool(global_data.get_randi(0,1)))
	$circle_effect.set_flip_v(bool(global_data.get_randi(0,1)))
	
	$circle_effect.show()
	$circle_effect.set_modulate(initial_color)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property($circle_effect, "modulate", Color(initial_color.r, initial_color.g, initial_color.b, 0), time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback($circle_effect.hide)
	pass

func rectangle_effect(initial_color: Color, time: float):
	$ring_effect_grouping_node.hide()
	$circle_effect.hide()
	
	$rectangle_effect.show()
	$rectangle_effect.set_modulate(initial_color)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property($rectangle_effect, "modulate", Color(initial_color.r, initial_color.g, initial_color.b, 0), time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback($rectangle_effect.hide)
	pass

func ring_effect(time: float):
	$rectangle_effect.hide()
	$circle_effect.hide()
	
	$ring_effect_grouping_node.show()
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property($ring_effect_grouping_node/ring_effect1, "modulate", Color(0, 255, 0, 0), time / 3).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($ring_effect_grouping_node/ring_effect2, "modulate", Color(0, 255, 0, 0), time / 2).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($ring_effect_grouping_node/ring_effect3, "modulate", Color(0, 255, 0, 0), time).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback($ring_effect_grouping_node.hide)
	pass

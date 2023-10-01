extends Area3D
class_name BoostPickup

@export var BOOST_INCREASE: float
var is_used = false

var tween

func _physics_process(delta):
	$sprite.rotate_object_local(Vector3(0,1,0), delta)
	$sprite.rotate_object_local(Vector3(1,0,0), delta)
	$sprite.rotate_object_local(Vector3(0,0,1), delta)
	pass

func set_is_used(value: bool):
	match value:
		true:
			is_used = true
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property($sprite, "modulate", Color(0, 0, 0, 255), 0.25)
		false:
			is_used = false
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property($sprite, "modulate", Color(255, 255, 255, 255), 0.25)
	pass

func _on_body_entered(body):
	if is_used == false:
		if body is Player:
			if game_data.player.current_checkpoint:
				body.BOOST_TIME += BOOST_INCREASE
				set_is_used(true)
				game_data.hud_effect.circle_effect(Color.GOLD, 0.5)
	pass

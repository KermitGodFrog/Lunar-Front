extends Sprite3D
var advertisement_one = preload("res://Scenes/Trade Route Map/advertisement_one.png")
var advertisement_two = preload("res://Scenes/Trade Route Map/advertisement_two.png")
var advertisement_three = preload("res://Scenes/Trade Route Map/advertisement_three.png")

@onready var advertisements = [advertisement_one, advertisement_two, advertisement_three]

func _on_timer_timeout():
	set_texture(advertisements.pick_random())
	$timer.start(global_data.get_randf(15,30))
	pass 

extends StaticBody3D
@export var ROTATION_SPEED: int = 10

func _physics_process(delta):
	rotation.y += deg_to_rad(ROTATION_SPEED) * delta
	pass

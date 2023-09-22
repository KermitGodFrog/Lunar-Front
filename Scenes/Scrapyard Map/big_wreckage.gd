extends AnimatableBody3D
@export var rotation_speed: float


func _physics_process(delta):
	rotation.y += deg_to_rad(rotation_speed) * delta
	pass

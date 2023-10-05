extends StaticBody3D

@export var axis: Vector3
@export var rotation_amount: float

var starting_basis: Basis

func _ready():
	starting_basis = transform.basis
	pass

func _physics_process(delta):
	rotate_object_local(axis, deg_to_rad(rotation_amount) * delta)
	pass

func _on_race_start():
	basis = starting_basis
	pass

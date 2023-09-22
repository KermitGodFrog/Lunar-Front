extends Node

var base_node
var player
var hud_effect

func get_mouse_to_3d():
	var space_state = base_node.get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(mouse_position) * 1000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 1))
	return [ray_end, intersection]

func spawn_pd_round(spawning_body: Object, spawn_speed: int, DAMAGE: int, spawn_transform: Transform3D):
	var pd_round = preload("res://Instantiated Scenes/PD Round/pd_round.tscn")
	var pd_round_instance = pd_round.instantiate()
	base_node.add_child(pd_round_instance)
	
	pd_round_instance.transform = spawn_transform
	pd_round_instance.velocity += -pd_round_instance.basis.z * spawn_speed
	pd_round_instance.velocity += spawning_body.velocity
	pd_round_instance.DAMAGE = DAMAGE
	pass

func spawn_missile(spawning_body: Object, spawn_velocity: Vector3, ACCELERATION_FORWARD: int, MAX_SPEED: int, DAMAGE: int, spawn_transform: Transform3D):
	var missile = preload("res://Instantiated Scenes/Missile/missile.tscn")
	var missile_instance = missile.instantiate()
	missile_instance.transform = spawn_transform
	missile_instance.velocity = spawning_body.velocity + spawn_velocity
	missile_instance.ACCELERATION_FORWARD = ACCELERATION_FORWARD
	missile_instance.MAX_SPEED = MAX_SPEED
	missile_instance.DAMAGE = DAMAGE
	base_node.add_child(missile_instance)
	pass

func get_closest_body(bodies, global_position):
	if bodies.size() > 0:
		var distance_to_bodies: Dictionary
		
		for body in bodies:
			distance_to_bodies[body] = global_position.distance_to(body.global_position)
		distance_to_bodies.values().sort()
		return distance_to_bodies.find_key(distance_to_bodies.values()[0])
	else:
		return null

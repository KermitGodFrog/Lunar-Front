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

func get_closest_body(bodies, global_position):
	if bodies.size() > 0:
		var distance_to_bodies: Dictionary
		
		for body in bodies:
			distance_to_bodies[body] = global_position.distance_to(body.global_position)
		distance_to_bodies.values().sort()
		return distance_to_bodies.find_key(distance_to_bodies.values()[0])
	else:
		return null

extends Node

var base_node
var player

func spawn_pd_round(spawning_body: Object, spawn_speed: int, DAMAGE: int, spawn_transform: Transform3D):
	var pd_round = preload("res://Instantiated Scenes/PD Round/pd_round.tscn")
	var pd_round_instance = pd_round.instantiate()
	base_node.add_child(pd_round_instance)
	
	
	pd_round_instance.transform.origin = spawn_transform.origin
	pd_round_instance.transform.basis = spawn_transform.basis
	
	
	pd_round_instance.velocity += -pd_round_instance.basis.z * spawn_speed
	pd_round_instance.velocity += spawning_body.velocity
	pd_round_instance.DAMAGE = DAMAGE
	
	
	print("pd round ", pd_round_instance.transform.basis)
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

func get_randi(from: int, to: int):
	return RandomNumberGenerator.new().randi_range(from, to)

func get_randf(from: float, to: float):
	return RandomNumberGenerator.new().randf_range(from, to)

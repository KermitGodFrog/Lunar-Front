extends CharacterBody3D
class_name TurretBase

@export var health: Health

@export_enum("Fixed", "Face Mouse Pointer", "Face Closest Enemy", "Face Closest Enemy + Lead Shots", "Face Closest Missile", "Face Closest Missile + Lead Shots", "Face Closest Player", "Face Closest Player + Lead Shots") var turret_mode
@export_range(0, 2, 1.0) var weapon_group: int

@export var PROJECTILE_SPEED: int

@export_node_path("CharacterBody3D") var base_node
@export_node_path("Marker3D") var spawn_marker
@export_node_path("Timer") var cooldown_timer
@export_node_path("RayCast3D") var short_range_raycast
@export_node_path("RayCast3D") var long_range_raycast

var target: Object

func _ready():
	health.reset()
	health.health_changed.connect(_on_health_changed)
	get_parent().commence_firing.connect(_on_commence_firing)
	pass

#FIRING

func _on_commence_firing(for_weapon_group):
	if weapon_group == for_weapon_group:
		if turret_mode > 1 and target != null:
			main_check()
		elif turret_mode <= 1:
			main_check()
	pass

func main_check():
	if get_node(cooldown_timer).is_stopped() == true:
		if get_node(short_range_raycast).is_colliding() == false:
			raycast_check()
		elif get_node(short_range_raycast).get_collider() != get_parent():
			raycast_check()
	pass

func raycast_check():
	if turret_mode == 2 or turret_mode == 4 or turret_mode == 6:
		if get_node(long_range_raycast).is_colliding() == true:
			if get_node(long_range_raycast).get_collider() == target:
				
				get_node(cooldown_timer).start()
				commence_firing()
	if turret_mode == 3 or turret_mode == 5 or turret_mode == 7:
		if get_node(long_range_raycast).is_colliding() == false:
			
			get_node(cooldown_timer).start()
			commence_firing()
		else:
			var distance_to_target = global_transform.origin.distance_to(target.global_transform.origin)
			var distance_to_raycast_collision = global_transform.origin.distance_to(get_node(long_range_raycast).get_collider().global_transform.origin)
			if distance_to_target < distance_to_raycast_collision:
				
				get_node(cooldown_timer).start()
				commence_firing()
			elif get_node(long_range_raycast).get_collider() == target:
				
				get_node(cooldown_timer).start()
				commence_firing()
	if turret_mode == 0 or turret_mode == 1:
		
		get_node(cooldown_timer).start()
		commence_firing()
	pass

func commence_firing():
	#USED BY INHERITED SCRIPTS
	pass

#ROTATION AND TARGETING

func _physics_process(delta):
	match turret_mode:
		0:
			target = null
		1:
			look_at(get_mouse_to_3d()[0])
			target = null
		2:
			var closest_enemy = game_data.get_closest_body(get_tree().get_nodes_in_group("enemy"), global_transform.origin)
			if closest_enemy != null:
				look_at(closest_enemy.transform.origin, Vector3(0, 0, -1))
				target = closest_enemy
		3:
			var closest_enemy = game_data.get_closest_body(get_tree().get_nodes_in_group("enemy"), global_transform.origin)
			if closest_enemy != null:
				look_at(closest_enemy.transform.origin + closest_enemy.velocity * ((closest_enemy.velocity - get_parent().velocity).length() / (get_parent().velocity + -transform.basis.z * PROJECTILE_SPEED).length()), Vector3(0, 0, -1))
				target = closest_enemy
		4:
			var closest_missile = game_data.get_closest_body(get_tree().get_nodes_in_group("missile"), global_transform.origin)
			if closest_missile != null:
				look_at(closest_missile.transform.origin, Vector3(0, 0, -1))
				target = closest_missile
		5:
			var closest_missile = game_data.get_closest_body(get_tree().get_nodes_in_group("missile"), global_transform.origin)
			if closest_missile != null:
				look_at(closest_missile.transform.origin + closest_missile.velocity * ((closest_missile.velocity - get_parent().velocity).length() / (get_parent().velocity + -transform.basis.z * PROJECTILE_SPEED).length()), Vector3(0, 0, -1))
				target = closest_missile
		6:
			var closest_player = game_data.get_closest_body(get_tree().get_nodes_in_group("player"), global_transform.origin)
			if closest_player != null:
				look_at(closest_player.transform.origin, Vector3(0, 0, -1))
				target = closest_player
		7:
			var closest_player = game_data.get_closest_body(get_tree().get_nodes_in_group("player"), global_transform.origin)
			if closest_player != null:
				look_at(closest_player.transform.origin + closest_player.velocity * ((closest_player.velocity - get_parent().velocity).length() / (get_parent().velocity + -transform.basis.z * PROJECTILE_SPEED).length()), Vector3(0, 0, -1))
				target = closest_player
	pass

#UTILITY

func get_mouse_to_3d():
	var space_state = get_parent().get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(mouse_position) * 1000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 1))
	return [ray_end, intersection]

func _on_health_changed(current_health):
	if current_health == 0:
		queue_free()
	pass
	

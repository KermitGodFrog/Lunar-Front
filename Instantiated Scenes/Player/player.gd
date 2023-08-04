extends CharacterBody3D

@export var health: Health

const ACCELERATION_FORWARD = 1.0
const ACCELERATION_MOVEMENT = 1.0
const YAW_SPEED = 1.0
const PITCH_SPEED = 1.0
const ROLL_SPEED = 1.0

var rot_x: float
var rot_y: float
var mouse_sens = 0.1

var is_right_mouse_button_down = false
var is_left_mouse_button_down = false
var is_fa_toggle = false

var selected_fire_group: int
signal commence_firing

func _ready():
	health.reset()
	health.health_changed.connect(_on_health_changed)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_data.player = self
	pass

func _input(event):         
	if event is InputEventMouseMotion:
		if is_right_mouse_button_down == true:
			rot_x += event.relative.x * deg_to_rad(mouse_sens)
			rot_y += event.relative.y * deg_to_rad(mouse_sens)
			$camera_offset.transform.basis = Basis()
			$camera_offset.rotate_object_local(Vector3(0, -1, 0), rot_x)
			$camera_offset.rotate_object_local(Vector3(1, 0, 0), rot_y)
		if is_left_mouse_button_down == true:
			if event.relative.y < 0:
				$camera_offset/camera.position.z = lerp($camera_offset/camera.position.z, $camera_offset/camera.position.z + 2.5, 0.7)
			if event.relative.y > 0:
				$camera_offset/camera.position.z = lerp($camera_offset/camera.position.z, $camera_offset/camera.position.z - 2.5, 0.7)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_right_mouse_button_down = event.pressed
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_left_mouse_button_down = event.pressed
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			pass
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			pass
	pass

func _physics_process(delta):
	movement()
	weapons()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5
		#rotation = rotation.bounce(-collision.get_normal()) * 0.8
	pass

func movement():
	var is_accelerating = false
	
	if Input.is_action_just_pressed("fa_toggle"):
		is_fa_toggle = !is_fa_toggle
	
	var accelerate_dir = Input.get_axis("accelerate_backward", "accelerate_forward")
	if accelerate_dir:
		velocity += global_transform.basis.z * accelerate_dir * ACCELERATION_FORWARD
		is_accelerating = true
	
	var move_x_dir = Input.get_axis("move_right", "move_left")
	var move_y_dir = Input.get_axis("move_down", "move_up")
	if move_x_dir:
		velocity += global_transform.basis.x * move_x_dir * ACCELERATION_MOVEMENT
		is_accelerating = true
	if move_y_dir:
		velocity += global_transform.basis.y * move_y_dir * ACCELERATION_MOVEMENT
		is_accelerating = true
	
	var yaw_dir = Input.get_axis("yaw_up", "yaw_down")
	if yaw_dir:
		rotate_object_local(Vector3(yaw_dir, 0, 0), deg_to_rad(YAW_SPEED))
	
	var pitch_dir = Input.get_axis("pitch_right", "pitch_left")
	if pitch_dir:
		rotate_object_local(Vector3(0, pitch_dir, 0), deg_to_rad(PITCH_SPEED))
	
	var roll_dir = Input.get_axis("roll_left", "roll_right")
	if roll_dir:
		rotate_object_local(Vector3(0, 0, roll_dir), deg_to_rad(ROLL_SPEED))
	
	if is_fa_toggle == true and is_accelerating == false:
		velocity = lerp(velocity, Vector3.ZERO, 0.01)
	pass

func weapons():
	if Input.is_action_just_pressed("switch_fire_group_zero"):
		selected_fire_group = 0
	if Input.is_action_just_pressed("switch_fire_group_one"):
		selected_fire_group = 1
	if Input.is_action_just_pressed("switch_fire_group_two"):
		selected_fire_group = 2
	
	if Input.is_action_pressed("commence_firing"):
		emit_signal("commence_firing", selected_fire_group)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	#var point_at_mouse_nodes = get_tree().get_nodes_in_group("point_at_mouse")
	#for node in point_at_mouse_nodes:
		#node.look_at(get_mouse_to_3d()[0], Vector3(0, 0, -1))
	
	#var new_point_at_mouse_nodes = get_tree().get_nodes_in_group("new_point_at_mouse")
	#for node in new_point_at_mouse_nodes:
		#var a = Vector2(get_mouse_to_3d()[0].x, get_mouse_to_3d()[0].z)
		#var b = Vector2(node.get_child(2).global_transform.origin.x, node.get_child(2).global_transform.origin.z)
		#var diff = Vector2(a.x - b.x, a.y - b.y)
		#node.get_child(2).transform.basis = Basis()
		#node.get_child(2).rotate_object_local(Vector3(0, 1, 0), -atan2(diff.y, diff.x))
		#does not acocunt for ship rotation
		#maybe work if in nodes own script? Or by adding ships rotation to it each time?
	
	
	#var point_at_closest_enemy_nodes = get_tree().get_nodes_in_group("point_at_closest_enemy")
	#for node in point_at_closest_enemy_nodes:
		#var closest_enemy = game_data.get_closest_body(get_tree().get_nodes_in_group("enemy"), node.global_position)
		#if closest_enemy != null:
			#node.look_at(closest_enemy.transform.origin + closest_enemy.velocity * ((closest_enemy.velocity - velocity).length() / (velocity + -node.basis.z * BULLET_SPEED).length()))
			#node.look_at(closest_enemy.transform.origin + closest_enemy.velocity * BULLET_SPEED)
			#node.look_at(closest_enemy.transform.origin + closest_enemy.velocity * (closest_enemy.velocity - velocity).length() / BULLET_SPEED)
	
	
	#if Input.is_action_pressed("fire"):
		#if $fire_cooldown.is_stopped() == true:
			#for node in point_at_closest_enemy_nodes:
				#if game_data.manual_fire_check(self, node, node.get_child(1)) == true:
					#game_data.spawn_pd_round(self, BULLET_SPEED, 1, node.get_child(0).global_transform)
			#$fire_cooldown.start()
	pass



func get_mouse_to_3d():
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(mouse_position) * 1000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 1))
	return [ray_end, intersection]


func _on_health_changed(current_health):
	if current_health == 0:
		queue_free()
	pass


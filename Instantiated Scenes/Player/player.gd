extends CharacterBody3D
class_name Player

@export var health: Health

#MOVEMENT

const ACCELERATION_FORWARD = 1.5
const ACCELERATION_MOVEMENT = 1.5
const PITCH_SPEED = 50.0
const YAW_SPEED = 50.0
const ROLL_SPEED = 50.0
const ROTATION_INTERPOLATION = 0.025
const FA_INTERPOLATION = 0.010

var PITCH_TIME: float
var YAW_TIME: float
var ROLL_TIME: float

#BOOST

const BOOST_MULTIPLIER = 3

#MOUSE

var rot_x: float
var rot_y: float
var mouse_sens = 0.1

#WEAPONS

var selected_fire_group: int
signal commence_firing

#MISC

var is_left_mouse_button_down = false
var is_right_mouse_button_down = false
var is_fa_toggle = false
var is_first_person_toggle = false
var is_movement = false

func _ready():
	health.reset()
	health.health_changed.connect(_on_health_changed)
	game_data.player = self
	pass

func _input(event):
	if event is InputEventMouseMotion:
		match is_first_person_toggle:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				var event_normalized = event.relative.normalized()
				YAW_TIME = lerp(YAW_TIME, -event_normalized.x * YAW_SPEED, ROTATION_INTERPOLATION)
				PITCH_TIME = lerp(PITCH_TIME, event_normalized.y * PITCH_SPEED, ROTATION_INTERPOLATION)
			false:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	if event is InputEventJoypadMotion:
		match is_first_person_toggle:
			true:
				match event.axis:
					0:
						YAW_TIME = lerp(YAW_TIME, -1 * YAW_SPEED, ROTATION_INTERPOLATION)
					2:
						YAW_TIME = lerp(YAW_TIME, 1 * YAW_SPEED, ROTATION_INTERPOLATION)
					1:
						PITCH_TIME = lerp(PITCH_TIME, -1 * PITCH_SPEED, ROTATION_INTERPOLATION)
					3:
						PITCH_TIME = lerp(PITCH_TIME, 1 * PITCH_SPEED, ROTATION_INTERPOLATION)
			false:
				pass
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
	movement(delta)
	weapons()
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5
		#rotation = rotation.bounce(-collision.get_normal()) * 0.8
	pass

func movement(delta):
	is_movement = false
	
	if Input.is_action_just_pressed("fa_toggle"):
		is_fa_toggle = !is_fa_toggle
	
	if Input.is_action_just_pressed("first_person_toggle"):
		is_first_person_toggle = !is_first_person_toggle
		
		if is_first_person_toggle == true:
			$first_person_camera.set_current(true)
		if is_first_person_toggle == false:
			$camera_offset/camera.set_current(true)
		pass
	
	#ACCELERATION
	
	var accelerate_dir = Input.get_axis("accelerate_backward", "accelerate_forward")
	if accelerate_dir:
		velocity += global_transform.basis.z * accelerate_dir * ACCELERATION_FORWARD
		is_movement = true
	
	var move_x_dir = Input.get_axis("move_right", "move_left")
	var move_y_dir = Input.get_axis("move_down", "move_up")
	if move_x_dir:
		velocity += global_transform.basis.x * move_x_dir * ACCELERATION_MOVEMENT
		is_movement = true
	if move_y_dir:
		velocity += global_transform.basis.y * move_y_dir * ACCELERATION_MOVEMENT
		is_movement = true
	
	#ROTATION
	
	var pitch_axis = Input.get_axis("pitch_up", "pitch_down")
	if pitch_axis:
		PITCH_TIME = lerp(PITCH_TIME, pitch_axis * PITCH_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
	else:
		if is_fa_toggle == true:
			PITCH_TIME = lerp(PITCH_TIME, 0.0, ROTATION_INTERPOLATION)
	
	var yaw_axis = Input.get_axis("yaw_right", "yaw_left")
	if yaw_axis:
		YAW_TIME = lerp(YAW_TIME, yaw_axis * YAW_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
	else:
		if is_fa_toggle == true:
			YAW_TIME = lerp(YAW_TIME, 0.0, ROTATION_INTERPOLATION)
	
	var roll_axis = Input.get_axis("roll_left", "roll_right")
	if roll_axis:
		ROLL_TIME = lerp(ROLL_TIME, roll_axis * ROLL_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
	else:
		if is_fa_toggle == true:
			ROLL_TIME = lerp(ROLL_TIME, 0.0, ROTATION_INTERPOLATION)
	
	if PITCH_TIME != 0:
		rotate_object_local(Vector3(1, 0, 0), deg_to_rad(PITCH_TIME * delta))
	if YAW_TIME != 0:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(YAW_TIME * delta))
	if ROLL_TIME != 0:
		rotate_object_local(Vector3(0, 0, 1), deg_to_rad(ROLL_TIME * delta))
	
	if is_fa_toggle == true and is_movement == false:
		velocity = lerp(velocity, Vector3.ZERO, FA_INTERPOLATION)
	
	$pitch_thrusters.update_axis(pitch_axis)
	$pitch_thrusters.update_time(PITCH_TIME)
	
	$yaw_thrusters.update_axis(yaw_axis)
	$yaw_thrusters.update_time(YAW_TIME)
	
	$roll_thrusters.update_axis(-roll_axis)
	$roll_thrusters.update_time(-ROLL_TIME)
	
	$acceleration_thrusters.update_axis(accelerate_dir)
	$acceleration_thrusters.update_time(velocity.length())
	
	print(velocity.length())
	
	
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
	pass

#UTILITY

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


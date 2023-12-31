extends CharacterBody3D
class_name Player

@export var health: Health
@onready var initial_first_person_camera_basis = $first_person_camera.transform.basis

#GAMEPLAY

var current_checkpoint: Checkpoint
var current_time: float

#MOVEMENT

const ACCELERATION_FORWARD = 1.5
const ACCELERATION_MOVEMENT = 1.5
const PITCH_SPEED = 70.0
const YAW_SPEED = 50.0
const ROLL_SPEED = 50.0
var ROTATION_INTERPOLATION = 0.025
const FA_INTERPOLATION = 0.015
const SECRET_FA_INTERPOLATION = 0.010
const SPACE_BRAKE_INTERPLATION = 0.020

var PITCH_TIME: float
var YAW_TIME: float
var ROLL_TIME: float

#BOOST

var BOOST: int
var BOOST_STARTING_TIME: float = 300
var BOOST_TIME: float = BOOST_STARTING_TIME
const BOOST_MULTIPLIER = 3
const BOOST_REGEN_DIVIDER = 1.125
const BOOST_MAX_REGEN = 300

#MOUSE

var rot_x: float
var rot_y: float
var mouse_sens = 0.1
var headlook_mouse_sens = 1200

var mouse_relative_matrix: Array = [Vector2(0,0), 0]
var MOUSE_MOVEMENT_DEADZONE = 1.0
var MOUSE_MOVEMENT_SENSITIVTY = 10.0

#WEAPONS

var selected_fire_group: int
signal commence_firing

#CAMERA

var is_camera_offset_toggle = false
var CAMERA_OFFSET_LOCATION: Vector3 = Vector3(0,0,0)
const CAMERA_OFFSET_INTERPOLATION = 0.15
var is_camera_shake = true
var CAMERA_SHAKE_RETURN_INTERPOLATION: float = 0.05
var HEADLOOK_RETURN_INTERPOLATION: float = 0.10

#MISC

var is_left_mouse_button_down = false
var is_right_mouse_button_down = false

var is_fa_toggle = true
var is_first_person_toggle = false
var is_mouse_movement_toggle = false
var is_headlook_toggle = false
var is_movement = false
var is_acceleration = false
var is_rotation = false

const MAIN_ENGINE_ACCEL_LENGTH = 3.0
const MAIN_ENGINE_BOOST_LENGTH = 4.5
const MAIN_ENGINE_INTERPOLATION = 0.15

func _ready():
	game_data.player = self
	sync_settings()
	get_tree().paused = false
	
	health.reset()
	health.health_changed.connect(_on_health_changed)
	
	$first_person_camera.set_current(true)
	$first_person_camera/draw_control.show()
	$camera_offset/camera/draw_control.hide()
	is_first_person_toggle = true
	
	var always_visible_hud_elements = get_tree().get_nodes_in_group("always_visible_hud_element")
	always_visible_hud_elements.shuffle()
	for element in always_visible_hud_elements:
		await get_tree().create_timer(global_data.get_randf(0.05, 0.60)).timeout
		element.show()
		var sfx = [$click_sound_one, $click_sound_two]
		sfx.pick_random().play()
	pass

func _input(event):
	#SETTERS
	
	if event is InputEventMouseButton:
		if event.button_index == settings.third_person_rotate_camera_key:
			is_right_mouse_button_down = event.pressed
		if event.button_index == settings.third_person_zoom_key:
			is_left_mouse_button_down = event.pressed
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			pass
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			pass
	
	#CAMERA
	
	if event is InputEventMouseMotion:
		match is_first_person_toggle:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
				match is_headlook_toggle:
					true:
						Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
						$first_person_camera.rotation.y -= event.relative.x / headlook_mouse_sens
						$first_person_camera.rotation.x -= event.relative.y / headlook_mouse_sens
						$first_person_camera.rotation.x = clamp($first_person_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
					false:
						Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
						var normalized = event.relative.normalized()
						var distance = event.relative.distance_to(Vector2(0,0))
						if event.relative.x > MOUSE_MOVEMENT_DEADZONE or event.relative.x < -MOUSE_MOVEMENT_DEADZONE and event.relative.y > MOUSE_MOVEMENT_DEADZONE or event.relative.y < -MOUSE_MOVEMENT_DEADZONE:
							mouse_relative_matrix[0] = normalized
							mouse_relative_matrix[1] = distance * MOUSE_MOVEMENT_SENSITIVTY
						else:
							mouse_relative_matrix[0] = Vector2(0,0)
							mouse_relative_matrix[1] = 0
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
	pass

func _physics_process(delta):
	movement(delta)
	weapons()
	
	var camera_shake_body = get_tree().get_first_node_in_group("cause_player_camera_shake")
	if camera_shake_body:
		proximity_camera_shake(delta, camera_shake_body, 2.5, 1000)
	
	if current_checkpoint:
		current_time += delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5
		health.remove_health(abs(velocity.length()))
		game_data.hud_effect.circle_effect(Color.RED, 1)
		if velocity.length() < 50 and velocity.length() > 0 or velocity.length() > -50 and velocity.length() < 0:
			get_tree().get_nodes_in_group("damage_low").pick_random().play()
		else:
			get_tree().get_nodes_in_group("damage_high").pick_random().play()
	pass

func movement(delta):
	is_movement = false
	is_acceleration = false
	is_rotation = false
	
	#TOGGLES
	
	if Input.is_action_just_pressed("fa_toggle"):
		is_fa_toggle = !is_fa_toggle
		$fa_toggle_sound.play()
	
	#ACCELERATION
	
	var accelerate_dir = Input.get_axis("accelerate_backward", "accelerate_forward")
	if accelerate_dir:
		velocity += global_transform.basis.z * accelerate_dir * ACCELERATION_FORWARD * BOOST
		is_movement = true
		is_acceleration = true
		if accelerate_dir == 1:
			main_engine_shader_update(MAIN_ENGINE_ACCEL_LENGTH)
			$main_engine_sound.play($main_engine_sound.get_playback_position())
		else:
			main_engine_shader_update(0.0)
	else:
		main_engine_shader_update(0.0)
		$main_engine_sound.stop()
	
	var move_x_dir = Input.get_axis("move_right", "move_left")
	var move_y_dir = Input.get_axis("move_down", "move_up")
	if move_x_dir:
		velocity += global_transform.basis.x * move_x_dir * ACCELERATION_MOVEMENT * BOOST
		is_movement = true
		is_acceleration = true
	if move_y_dir:
		velocity += global_transform.basis.y * move_y_dir * ACCELERATION_MOVEMENT * BOOST
		is_movement = true
		is_acceleration = true
	
	#ROTATION
	
	var pitch_axis = Input.get_axis("pitch_up", "pitch_down")
	if pitch_axis:
		PITCH_TIME = lerp(PITCH_TIME, pitch_axis * PITCH_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
		is_rotation = true
	else:
		if is_fa_toggle == true:
			PITCH_TIME = lerp(PITCH_TIME, 0.0, ROTATION_INTERPOLATION)
	
	var yaw_axis = Input.get_axis("yaw_right", "yaw_left")
	if yaw_axis:
		YAW_TIME = lerp(YAW_TIME, yaw_axis * YAW_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
		is_rotation = true
	else:
		if is_fa_toggle == true:
			YAW_TIME = lerp(YAW_TIME, 0.0, ROTATION_INTERPOLATION)
	
	var roll_axis = Input.get_axis("roll_left", "roll_right")
	if roll_axis:
		ROLL_TIME = lerp(ROLL_TIME, roll_axis * ROLL_SPEED, ROTATION_INTERPOLATION)
		is_movement = true
		is_rotation = true
	else:
		if is_fa_toggle == true:
			ROLL_TIME = lerp(ROLL_TIME, 0.0, ROTATION_INTERPOLATION)
	
	if is_first_person_toggle == true and is_mouse_movement_toggle == true:
		YAW_TIME = -mouse_relative_matrix[0].x * clamp(mouse_relative_matrix[1], 0, YAW_SPEED)
		PITCH_TIME = mouse_relative_matrix[0].y * clamp(mouse_relative_matrix[1], 0, PITCH_SPEED)
	
	
	if PITCH_TIME != 0:
		rotate_object_local(Vector3(1, 0, 0), deg_to_rad(PITCH_TIME * delta))
	if YAW_TIME != 0:
		rotate_object_local(Vector3(0, 1, 0), deg_to_rad(YAW_TIME * delta))
	if ROLL_TIME != 0:
		rotate_object_local(Vector3(0, 0, 1), deg_to_rad(ROLL_TIME * delta))
	
	#FA
	var cameras = [$first_person_camera, $camera_offset/camera]
	for camera_type in cameras:
		camera_type.set_fov(lerp(camera_type.fov, 75.0, 0.01))
	
	var is_fa_active: bool
	
	if is_fa_toggle == true and is_movement == false:
		velocity = lerp(velocity, Vector3.ZERO, FA_INTERPOLATION)
		is_fa_active = true
		if velocity.length() > 1.0:
			for camera_type in cameras:
				camera_type.set_fov(lerp(camera_type.fov, 70.0, 0.01))
	
	if is_fa_toggle == true and is_rotation == true and is_acceleration == false:
		velocity = lerp(velocity, Vector3.ZERO, SECRET_FA_INTERPOLATION)
		if velocity.length() > 1.0:
			for camera_type in cameras:
				camera_type.set_fov(lerp(camera_type.fov, 72.5, 0.01))
	
	if Input.is_action_pressed("space_brake"):
		velocity = lerp(velocity, Vector3.ZERO, SPACE_BRAKE_INTERPLATION)
		is_fa_active = true
		if velocity.length() > 1.0:
			for camera_type in cameras:
				camera_type.set_fov(lerp(camera_type.fov, 65.0, 0.01))
	
	#I fucking hate this block of code (below). SO fucking ugly. 
	
	if is_fa_active == true:
		if velocity.length() > 1.0:
			if Input.is_action_pressed("space_brake"):
				$fa_sound_high_pitch.play($fa_sound_high_pitch.get_playback_position())
				$fa_sound.stop()
			else:
				$fa_sound.play($fa_sound.get_playback_position())
		else:
			$fa_sound.stop()
			$fa_sound_high_pitch.stop()
	else:
		$fa_sound.stop()
		$fa_sound_high_pitch.stop()
	
	#BOOSTING
	
	if Input.is_action_pressed("boost"):
		if is_movement:
			BOOST_TIME = maxi(0, BOOST_TIME - delta)
			if BOOST_TIME > 0:
				BOOST = BOOST_MULTIPLIER
				for camera_type in cameras:
					camera_type.set_fov(lerp(camera_type.fov, 80.0, 0.01))
				if accelerate_dir == 1:
					main_engine_shader_update(MAIN_ENGINE_BOOST_LENGTH)
			else:
				BOOST = 1
		else:
			BOOST = 1
	else:
		BOOST = 1
	
	if BOOST_TIME < BOOST_MAX_REGEN:
		BOOST_TIME += delta / BOOST_REGEN_DIVIDER
	
	if BOOST == BOOST_MULTIPLIER:
		$main_engine_sound.set_pitch_scale(1.2)
	else:
		$main_engine_sound.set_pitch_scale(1)
	
	#THRUSTERS
	
	$pitch_thrusters.update_axis(pitch_axis)
	$pitch_thrusters.update_time(PITCH_TIME)
	
	$yaw_thrusters.update_axis(yaw_axis)
	$yaw_thrusters.update_time(YAW_TIME)
	
	$roll_thrusters.update_axis(-roll_axis)
	$roll_thrusters.update_time(-ROLL_TIME)
	
	$acceleration_thrusters.update_axis(accelerate_dir)
	$movement_x_thrusters.update_axis(move_x_dir)
	$movement_y_thrusters.update_axis(-move_y_dir)
	
	if velocity.length() > 0.80:
		$acceleration_thrusters.update_time(velocity.normalized().dot(transform.basis.z))
		$movement_x_thrusters.update_time(velocity.normalized().dot(transform.basis.x))
		$movement_y_thrusters.update_time(-velocity.normalized().dot(transform.basis.y))
	else:
		$acceleration_thrusters.update_time(0)
		$movement_x_thrusters.update_time(0)
		$movement_y_thrusters.update_time(0)
	
	#SFX
	
	var play_thruster_normal: bool = false
	var play_thruster_high_pitch: bool = false
	
	var AXES = [pitch_axis, yaw_axis, -roll_axis, accelerate_dir, move_x_dir, -move_y_dir]
	for axis in AXES:
		if axis == 1 or axis == -1:
			play_thruster_high_pitch = true
	
	var ROTATION_TIMES = [PITCH_TIME, YAW_TIME, -ROLL_TIME]
	if is_fa_toggle == true and is_movement == false:
		for TIME in ROTATION_TIMES:
			if TIME > 0.80 or TIME < -0.80:
				play_thruster_normal = true
	
	var VELOCITY_TIMES = [velocity.normalized().dot(transform.basis.z), velocity.normalized().dot(transform.basis.x), -velocity.normalized().dot(transform.basis.y)]
	if is_fa_toggle == true and is_movement == false:
		for TIME in VELOCITY_TIMES:
			if velocity.length() > 0.80:
				if TIME > 0.80 or TIME < -0.80:
					play_thruster_normal = true
	
	if play_thruster_normal == true:
		$thruster_continuous.play($thruster_continuous.get_playback_position())
	else:
		$thruster_continuous.stop()
	if play_thruster_high_pitch == true:
		$thruster_continuous_high_pitch.play($thruster_continuous_high_pitch.get_playback_position())
	else:
		$thruster_continuous_high_pitch.stop()
	
	camera(delta)
	
	pass

func camera(_delta):
	if Input.is_action_just_pressed("enable_first_person_headlook"):
		is_headlook_toggle = !is_headlook_toggle
	if is_headlook_toggle == false:
		var slerp = $first_person_camera.transform.basis.slerp(initial_first_person_camera_basis, HEADLOOK_RETURN_INTERPOLATION)
		$first_person_camera.transform.basis = slerp
	
	if Input.is_action_just_pressed("first_person_toggle"):
		is_first_person_toggle = !is_first_person_toggle
		
		if is_first_person_toggle == true:
			$first_person_camera.set_current(true)
			$first_person_camera/draw_control.show()
			$camera_offset/camera/draw_control.hide()
		if is_first_person_toggle == false:
			$camera_offset/camera.set_current(true)
			$first_person_camera/draw_control.hide()
			$camera_offset/camera/draw_control.show()
	
	#CAMERA OFFSET
	
	match is_camera_offset_toggle:
		false:
			CAMERA_OFFSET_LOCATION = Vector3(0,0,0)
		true:
			CAMERA_OFFSET_LOCATION = Vector3(0,7,0)
	$camera_offset.position = $camera_offset.position.lerp(CAMERA_OFFSET_LOCATION, CAMERA_OFFSET_INTERPOLATION)
	
	#ACCELERATION CAMERA SHAKE
	
	var camera_shake_time: float
	if is_camera_shake == true:
		if is_acceleration:
			camera_shake_time = _delta
			
			var h_shake = global_data.get_randf(-0.5,0.5)
			var v_shake = global_data.get_randf(-0.5,0.5)
			
			$camera_offset/camera.h_offset = lerp($camera_offset/camera.h_offset, h_shake, camera_shake_time * BOOST)
			$camera_offset/camera.v_offset = lerp($camera_offset/camera.v_offset, v_shake, camera_shake_time * BOOST)
		else:
			$camera_offset/camera.h_offset = lerp($camera_offset/camera.h_offset, 0.0, CAMERA_SHAKE_RETURN_INTERPOLATION)
			$camera_offset/camera.v_offset = lerp($camera_offset/camera.v_offset, 0.0, CAMERA_SHAKE_RETURN_INTERPOLATION)
			camera_shake_time = 0.0
	
	#MOUSE MOVEMENT
	
	#if is_first_person_toggle == true and is_mouse_movement_toggle == true:
		#var viewport_rect_size = get_viewport().get_visible_rect().size
		
		#var mouse_pos = Vector2(get_viewport().get_mouse_position().x - viewport_rect_size.x / 2.0, get_viewport().get_mouse_position().y - viewport_rect_size.y / 2.0)
		#var mouse_pos_normalized = Vector2(mouse_pos).normalized()
		
		#var multiplication = clamp(mouse_pos.distance_to(Vector2.ZERO) / 100.0, 0, 1.5)
		
		#var reconstructed_clamped_pos = Vector2(clamp(mouse_pos.x, -245, 245) + viewport_rect_size.x / 2.0, clamp(mouse_pos.y, -245, 245) + viewport_rect_size.y / 2.0)
		#get_tree().call_group("draw_control", "update_mouse_pointer_position", reconstructed_clamped_pos)
		
		#if mouse_pos.x > 25 or mouse_pos.x < -25:
			#YAW_TIME = lerp(YAW_TIME, -mouse_pos_normalized.x * YAW_SPEED * multiplication, ROTATION_INTERPOLATION)
		#if mouse_pos.y > 25 or mouse_pos.y < -25:
			#PITCH_TIME = lerp(PITCH_TIME, mouse_pos_normalized.y * PITCH_SPEED * multiplication, ROTATION_INTERPOLATION)
	pass

func proximity_camera_shake(_delta, body, amount: float, begin_distance: float):
	var camera_shake_time: float
	if global_transform.origin.distance_to(body.global_transform.origin) < begin_distance:
		
		camera_shake_time = _delta
		
		var h_shake = global_data.get_randf(-amount, amount)
		var v_shake = global_data.get_randf(-amount, amount)
		
		$camera_offset/camera.h_offset = lerp($camera_offset/camera.h_offset, h_shake, camera_shake_time * BOOST)
		$camera_offset/camera.v_offset = lerp($camera_offset/camera.v_offset, v_shake, camera_shake_time * BOOST)
	else:
		$camera_offset/camera.h_offset = lerp($camera_offset/camera.h_offset, 0.0, CAMERA_SHAKE_RETURN_INTERPOLATION)
		$camera_offset/camera.v_offset = lerp($camera_offset/camera.v_offset, 0.0, CAMERA_SHAKE_RETURN_INTERPOLATION)
		camera_shake_time = 0.0
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

func _on_health_changed(current_health):
	if current_health == 0:
		get_tree().reload_current_scene()
	pass

func main_engine_shader_update(length: float):
	var main_engine = get_tree().get_first_node_in_group("player_main_engine")
	var lerp_to_new_length = lerp(main_engine.get_active_material(0).get_shader_parameter("engine_length"), length, MAIN_ENGINE_INTERPOLATION)
	main_engine.get_active_material(0).set_shader_parameter("engine_length", lerp_to_new_length)
	return

func sync_settings():
	is_mouse_movement_toggle = settings.first_person_mouse_control
	is_camera_shake = settings.acceleration_camera_shake
	is_camera_offset_toggle = settings.third_person_camera_offset
	mouse_sens = settings.third_person_sensitivity
	headlook_mouse_sens = settings.first_person_headlook_sensitivity
	MOUSE_MOVEMENT_SENSITIVTY = settings.mouse_movement_sensitivity
	MOUSE_MOVEMENT_DEADZONE = settings.mouse_movement_deadzone
	pass

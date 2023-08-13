extends CharacterBody3D

@export var health: Health

const SPEED = 150.0
var STARTING_VELOCITY: Vector3 = Vector3(0, 0, SPEED)
const ROTATION_INTERPOLATION = 0.25
const FA_INTERPOLATION = 0.50

@export var DAMAGE: int = 1

func _ready():
	health.reset()
	health.health_changed.connect(_on_health_changed)
	velocity = STARTING_VELOCITY
	pass

func _physics_process(delta):
	if velocity != Vector3.ZERO:
		velocity = lerp(velocity, global_transform.origin.direction_to(game_data.player.global_transform.origin + game_data.player.velocity * (game_data.player.velocity - velocity).length() / velocity.length()) * SPEED, FA_INTERPOLATION)
		velocity = velocity.limit_length(abs(game_data.player.velocity.length_squared()) + SPEED)
	
	transform.basis = lerp(transform.basis, transform.basis.looking_at(velocity.normalized()), ROTATION_INTERPOLATION)
	
	$raycast_offset/raycast.transform.basis = $raycast_offset/raycast.transform.basis.looking_at(game_data.player.global_transform.origin)
	
	move_and_slide()
	pass

func _on_area_body_entered(body):
	print("missile hit")
	if body.get("health") != null:
		body.health.remove_health(DAMAGE)
	queue_free()
	pass

func _on_health_changed(current_health):
	if current_health == 0:
		queue_free()
	pass

func _on_nav_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	pass

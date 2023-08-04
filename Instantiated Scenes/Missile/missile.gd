extends CharacterBody3D

@export var health: Health

var ACCELERATION_FORWARD: int = 10.0
var STARTING_VELOCITY: Vector3 = Vector3(0, 0, 10)
var MAX_SPEED: int = 500

@export var DAMAGE: int = 1

func _ready():
	health.reset()
	health.health_changed.connect(_on_health_changed)

	velocity = STARTING_VELOCITY
	pass

func _physics_process(delta):
	velocity += global_transform.basis.z * -1 * ACCELERATION_FORWARD
	look_at(game_data.player.position + game_data.player.velocity * (game_data.player.velocity - velocity).length() / velocity.length())
	
	velocity = velocity.limit_length(MAX_SPEED)
	
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

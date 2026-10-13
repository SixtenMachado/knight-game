extends CharacterBody3D

var turn_speed : float = 1
var movement_speed: float = 0.5
var added_chase_speed : float = 0.2
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)
var sees_player : bool = false
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.7

	# Make sure to not await during _ready.
	#actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if sees_player:
		set_movement_target(PlayerData.player.global_position + (PlayerData.player.global_position.direction_to(global_position) * 0.9))
		rotate_towards(PlayerData.player.global_position, delta)
	
	if not navigation_agent.is_navigation_finished():
		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		
		if not sees_player:
			rotate_towards(navigation_agent.target_position, delta)
		
		velocity = current_agent_position.direction_to(next_path_position) * (movement_speed + (float(sees_player) * added_chase_speed))
	else:
		velocity = Vector3.ZERO
	
	if !is_on_floor():
		velocity += get_gravity()
	
	move_and_slide()

func rotate_towards(target : Vector3, delta :float):
	var old_rotation = quaternion
	look_at(target, Vector3.UP, true)
	quaternion = old_rotation.slerp(quaternion, delta * turn_speed)
	rotation.x = 0
	rotation.z = 0


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	sees_player = true

func _on_area_3d_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	sees_player = false
	set_movement_target(PlayerData.player.global_position)

extends CharacterBody3D

@export var turn_speed : float = 1
@export var movement_speed: float = 0.5
@export var added_chase_speed : float = 0.2
@export var target_desired_distance = 0.7
@export var path_desired_distance = 0.5

@export_category("Node Buddies")
@export var home_node : Node3D

var sees_player : bool = false
var hunting : bool = false
var look_target : Vector3

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = path_desired_distance
	navigation_agent.target_desired_distance = target_desired_distance
	navigation_agent.navigation_finished.connect(_on_navigation_finished)
	wait_then_return(0.2)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	navigation_agent.target_desired_distance = target_desired_distance
	navigation_agent.path_desired_distance = path_desired_distance

func _physics_process(delta):
	if sees_player:
		set_movement_target(PlayerData.player.global_position + (PlayerData.player.global_position.direction_to(global_position) * 0.9))
		look_target = PlayerData.player.global_position
	
	if not navigation_agent.is_navigation_finished():
		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		
		if not sees_player:
			look_target = navigation_agent.target_position
		
		velocity = current_agent_position.direction_to(next_path_position) * (movement_speed + (float(sees_player) * added_chase_speed))
		print(velocity)
	else:
		velocity = Vector3.ZERO
		
	if !is_on_floor():
		velocity += get_gravity()
	
	rotate_towards(delta)
	move_and_slide()

func rotate_towards(delta :float):
	var old_rotation = quaternion
	look_at(look_target, Vector3.UP, true)
	quaternion = old_rotation.slerp(quaternion, delta * turn_speed)
	rotation.x = 0
	rotation.z = 0

func wait_then_return(wait_time : float = 1):
	print("balatro")
	hunting = false
	await get_tree().create_timer(wait_time).timeout
	if !(sees_player or hunting):
		set_movement_target(home_node.global_position)
		navigation_agent.target_desired_distance = 0.3
		navigation_agent.path_desired_distance = 0.3
		
func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	sees_player = true
	hunting = false

func _on_area_3d_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	sees_player = false
	hunting = true
	set_movement_target(PlayerData.player.global_position)

func _on_navigation_finished():
	print("NAV FINISHED")
	if hunting:
			wait_then_return()
		#If we're home look in the direction we've decided
	if navigation_agent.target_position == home_node.global_position:
		look_target = home_node.global_basis.z
		print("swing your arme")

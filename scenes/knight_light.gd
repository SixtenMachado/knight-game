@tool
class_name KnightLight
extends OmniLight3D

@export var radius : float = 1.0:
	set(new_radius):
		radius = new_radius
		omni_range = radius
		collision_sphere.radius = radius * (clampf(energy_override, 0, 1) * 0.8)
		raycast.target_position.z = -radius * (clampf(energy_override, 0, 1) * 0.8)

@export_category("Flicker")
@export var flicker_enabled : bool = false:
	set(new):
		flicker_enabled = new
		if flicker_enabled:
			flicker.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			flicker.process_mode = Node.PROCESS_MODE_DISABLED
@export var energy_override : float = 1.0:
	set(new):
		flicker.energy_override = new
		energy_override = new
@export var floor_mult : float = 0.9:
	set(new):
		flicker.floor_mult = new
		floor_mult = new
@export var min_time : float = 0.05:
	set(new):
		flicker.min_time = new
		min_time = new
@export var max_time : float = 0.1:
	set(new):
		flicker.max_time = new
		max_time = new
	get:
		return max_time

@export_category("Node Buddies")
@export var collision_sphere : SphereShape3D
@export var raycast : RayCast3D
@export var flicker : LightFlicker

var player : Player
var sees_player : bool = false

func _ready() -> void:
	collision_sphere.radius = radius * (clampf(energy_override, 0, 1))
	raycast.target_position.z = -radius * (clampf(energy_override, 0, 1))

func _process(delta: float) -> void:
	#TODO: refactor into knight instead
	if player:
		raycast.look_at(player.global_position + Vector3(0, 1, 0))
		sees_player = !raycast.is_colliding()
		player.in_light = !raycast.is_colliding()
	else: 
		sees_player = false
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body as Player

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		player.in_light = false
		player = null

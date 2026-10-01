extends Node
class_name Act

@export var turn_speed : float = 10

@export_category("Node Buddies")
@export var player : Player

var acting : bool = false
var holding : bool = false
var deadzone : float = 0.5
var look_direction : Vector3
var smooth_direction : Vector3


func _ready() -> void:
	look_direction = -player.global_basis.z

func _process(delta: float) -> void:
	var direction : Vector3
	var cam = get_viewport().get_camera_3d()
	direction = cam.global_basis.x.cross(Vector3.UP) * Input.get_axis("act_backward","act_forward")
	direction += cam.global_basis.x * Input.get_axis("act_right", "act_left")
	
	#Numpad diagonals
	direction += (cam.global_basis.x - cam.global_basis.x.cross(Vector3.UP)).normalized() * Input.get_axis("diagonal_fr", "diagonal_bl")
	direction += (cam.global_basis.x + cam.global_basis.x.cross(Vector3.UP)).normalized() * Input.get_axis("diagonal_br", "diagonal_fl")
	
	if direction.length() > 0.9:
		if not acting:
			if Input.is_action_pressed("snuffer"):
				acting = true
				player.disable_movement(0.4, false)
				look_direction = direction
				smooth_direction = direction
				
		elif player.timer.is_stopped():
			if Input.is_action_pressed("snuffer"):
				holding = true
			else:
				holding = false
				acting = false
				$"../TestPivot".hide()
		
		if holding:
			look_direction = direction
		elif not acting:
			player.enable_movement()
			look_direction = direction
		
	if player.is_rotating:
		smooth_direction = -player.global_basis.z
		look_direction = -player.global_basis.z
	else:
		smooth_direction = smooth_direction.slerp(look_direction, turn_speed * delta)
		player.global_basis = player.global_basis.slerp(Basis.looking_at(smooth_direction), 1)
	
	if direction.length() <= deadzone and player.timer.is_stopped():
			player.enable_movement()
			acting = false
			holding = false
			#look_direction = -player.global_basis.z
			smooth_direction = -player.global_basis.z

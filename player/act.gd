extends Node
@export var player : Player
var acted: bool = false

func _process(delta: float) -> void:
	var direction : Vector3
	var cam = get_viewport().get_camera_3d()
	direction = cam.global_basis.x.cross(Vector3.UP) * Input.get_axis("act_backward","act_forward")
	direction += cam.global_basis.x * Input.get_axis("act_right", "act_left")
	print(direction.length())
	
	if direction.length() > 0.9 and not acted:
		acted = true
		player.look_at(player.global_position + direction)
		$"../TestPivot".look_at(player.global_position + direction)
		$"../TestPivot".show()
	
	elif direction.length() == 0:
		acted = false
		$"../TestPivot".hide()

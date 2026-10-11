extends MeshInstance3D

var mat : ShaderMaterial
@export var player : Player

func _ready() -> void:
	mat = get_active_material(8) as ShaderMaterial
	if not mat:
		process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mat.set_shader_parameter("emission_mult", player.in_light)

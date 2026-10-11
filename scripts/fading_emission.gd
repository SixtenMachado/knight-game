extends Node
class_name FadingEmission

@export var mesh_to_fade : MeshInstance3D
@export var material_slot : int = 0
@export var fade_speed : float = 3
@export var fade_to : float = 0 

func _ready() -> void:
	if self.is_class("MeshInstance3D"):
		mesh_to_fade = get_parent().get_child(get_index()) as MeshInstance3D
		print(mesh_to_fade)
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	var mat = mesh_to_fade.get_active_material(material_slot) as ShaderMaterial
	var amount : float = mat.get_shader_parameter("emission_mult")
	mat.set_shader_parameter("emission_mult", lerpf(amount, fade_to, delta * fade_speed))
	if is_equal_approx(amount, fade_to):
		process_mode = Node.PROCESS_MODE_DISABLED

@tool
class_name AutoShaderApplication
extends Node

var world_node : Node

static var universal_shader_opaque : Shader = preload("res://assets/shaders/universal_shader_opaque.gdshader")
static var universal_shader_transparent : Shader = preload("res://assets/shaders/universal_shader_transparent.gdshader")

func _ready() -> void:
	world_node = get_parent()
	if Engine.is_editor_hint():
		get_tree().node_added.connect(apply_shader)

func apply_shader(node: Node):
	if node is MeshInstance3D:
		if not world_node.is_ancestor_of(node):
			print("you are not an ancestor!")
			return
		
		print("node is: ", node)
		
		node.get_parent_node_3d().set_editable_instance(node, true)
		
		var mesh = node as MeshInstance3D
		for i in mesh.get_surface_override_material_count():
			if not mesh.get_surface_override_material(i):
				var material_name : String = mesh.get_active_material(i).to_string().get_slice(" ", 0)
				var texture_name := material_name.get_slice("_", 0)
				print(texture_name, " ", material_name)
				
				
				
				var material_path = str("res://assets/materials/", material_name, ".tres")
				if not FileAccess.file_exists(material_path):
					print("material ", material_name, " doesn't exist yet! Creating it now.")
					
					var new_material : ShaderMaterial = ShaderMaterial.new()
					if material_name.contains("transparent"):
						new_material.shader = universal_shader_transparent
					else:
						new_material.shader = universal_shader_opaque
					new_material.set_shader_parameter("red_color", Color.WHITE)
					ResourceSaver.save(new_material, material_path)
				
				var material : ShaderMaterial = load(material_path)
				var texture_path : String = str("res://textures/", texture_name, ".png")
				material.set_shader_parameter("input_texture", load(texture_path))
				mesh.set_surface_override_material(i, material)

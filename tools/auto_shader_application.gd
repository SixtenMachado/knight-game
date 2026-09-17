@tool
class_name AutoShaderApplication
extends Node

var shader_material : ShaderMaterial = preload("res://assets/shaders/shader_material.tres")
var world_node : Node


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
					ResourceSaver.save(shader_material, material_path)
				
				var material : ShaderMaterial = load(material_path)
				var texture_path : String = str("res://textures/", texture_name, ".png")
				material.set_shader_parameter("input_texture", load(texture_path))
				mesh.set_surface_override_material(i, material)
				
				#Maybe do something with this???
				#material.take_over_path(material_path)
				#ResourceSaver.save(material, material_path)

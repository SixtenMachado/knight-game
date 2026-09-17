@tool extends Area3D
class_name CameraZone
@export var camera : Camera3D;
@export var collision_shape : CollisionShape3D;

signal player_entered_area;
signal player_exited_area;

func player_entered_check(body) -> void:
	if body is not Player:
		return;
	camera.make_current();
	player_entered_area.emit();
func player_exited_check(body) -> void:
	if body is not Player:
		return;
	player_exited_area.emit();
	
func _ready() -> void:
	body_entered.connect(player_entered_check);
	body_exited.connect(player_exited_check);
	if Engine.is_editor_hint():
		if camera == null:
			var new_camera : Camera3D = load("res://scenes/knight_camera_3d.tscn").instantiate();
			add_child(new_camera,true);
			new_camera.owner = get_tree().edited_scene_root;
			camera = new_camera;
		if collision_shape == null:
			var new_collision_shape : CollisionShape3D = CollisionShape3D.new();
			add_child(new_collision_shape,true);
			new_collision_shape.owner = get_tree().edited_scene_root;
			collision_shape = new_collision_shape;
			collision_shape.shape = BoxShape3D.new();
		else:
			collision_shape.shape = collision_shape.shape.duplicate();
			

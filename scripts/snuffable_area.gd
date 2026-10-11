@tool
extends Area3D
class_name SnuffableArea

@export var light : KnightLight
@export var fade : FadingEmission
@export var collision_shape : CollisionShape3D;
@export var sound : AudioStream = preload("res://audio/player/snuff short.wav")

signal snuffed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_area_entered)
	if Engine.is_editor_hint():
		if collision_shape == null:
			var new_collision_shape : CollisionShape3D = CollisionShape3D.new();
			add_child(new_collision_shape,true);
			new_collision_shape.owner = get_tree().edited_scene_root;
			collision_shape = new_collision_shape;
			collision_shape.shape = BoxShape3D.new();
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			set_collision_mask_value(6, true)
		else:
			collision_shape.shape = collision_shape.shape.duplicate();
			
func on_area_entered(area : Area3D):
	print("snuff that")
	if fade:
		fade.process_mode = Node.PROCESS_MODE_INHERIT
	AudioManager.play_sound(sound, area.global_position, "Sound", 3)
	snuffed.emit()
	light.queue_free()
	

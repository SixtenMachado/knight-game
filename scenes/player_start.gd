extends Marker3D
class_name PlayerStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = load("res://player/player.tscn").instantiate()
	get_parent_node_3d().add_child.call_deferred(player)
	player.transform = transform

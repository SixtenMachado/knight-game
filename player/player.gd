extends CharacterBody3D
class_name Player

@export var speed : float = 4.5;
@export var rotate_speed : float = 5.1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	tank_controls(delta)
	move_and_slide()

func tank_controls(delta) -> void:
	if not is_on_floor():
		velocity.y = -20;
	var move_input = Input.get_axis("move_backward","move_forward");
	var rotate_input = Input.get_axis("turn_left","turn_right");
	rotate(Vector3.DOWN, rotate_input * rotate_speed * delta);    
	var direction = (transform.basis * Vector3(0, 0, move_input)).normalized();
	if direction != null:
			velocity.x = direction.x * speed;
			velocity.z = direction.z * speed;
	else:
		velocity.x = move_toward(velocity.x, 0, speed);
		velocity.z = move_toward(velocity.z, 0, speed);

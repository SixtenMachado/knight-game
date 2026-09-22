extends CharacterBody3D
class_name Player

@export var speed : float = 4.5;
@export var rotate_speed : float = 5.1;
@export var strafe_relative_speed : float = 0.5;
@export var timer : Timer

var is_disable_movement = false
var enable_movement_buffer = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_disable_movement: return
	tank_rotate(delta)
	strafe_controls(delta)
	move_and_slide()

func strafe_controls(delta) -> void:
	if not is_on_floor():
		velocity.y = -20;
	var move_input = Input.get_axis("move_backward","move_forward");
	var strafe_input = Input.get_axis("strafe_right", "strafe_left");
	var direction = (transform.basis * Vector3(strafe_input, 0, move_input)).normalized();
	print(1 + direction.dot(transform.basis.z))
	if direction != null:
			velocity.x = direction.x * speed;
			velocity.z = direction.z * speed;
			velocity = velocity * (3 + direction.dot(transform.basis.z)) / 5
	else:
		velocity.x = move_toward(velocity.x, 0, speed);
		velocity.z = move_toward(velocity.z, 0, speed);

func tank_rotate(delta) -> void:
	var rotate_input = Input.get_axis("turn_left","turn_right");
	rotate(Vector3.DOWN, rotate_input * rotate_speed * delta);    

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

func disable_movement(time : float = 0.2, enable_on_timeout : bool = false):
	is_disable_movement = true
	enable_movement_buffer = enable_on_timeout
	timer.wait_time = time
	timer.start()

func enable_movement():
	if timer.is_stopped():
		is_disable_movement = false
	else: 
		enable_movement_buffer = true

func _on_movement_disable_timer_timeout() -> void:
	if enable_movement_buffer:
		enable_movement()

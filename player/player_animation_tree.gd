extends AnimationTree
@export var player : Player
@export var act : Act

@onready var state_machine : AnimationNodeStateMachinePlayback = self.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if act.acting:
		state_machine.travel("Snuff")
		return
	
	var speed = (player.velocity * Vector3(1,0,1)).length()
	if speed == 0 and player.is_rotating:
		if player.rotate_input > 0:
			state_machine.travel("Turn_R")
		else:
			state_machine.travel("Turn_L")
		return
	
	else:
		state_machine.travel("Locomotion")
		self.set("parameters/Locomotion/blend_position", Vector2(-player.strafe_input, player.move_input))

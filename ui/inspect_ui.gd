extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hobbit"):
		if visible:
			$AnimationPlayer.play("vanish")
		else:
			$AnimationPlayer.play("appear")

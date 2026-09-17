extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hobbit") or event.is_action_pressed("ui_cancel"):
		stop()
		play("new_animation")
		$Jermachimp4.play()

extends Control
class_name InspectUI

var se : RichTextLabel
var en : RichTextLabel

func _ready() -> void:
	UiManager.inspect_ui = self

func appear():
	$AnimationPlayer.play("appear")

func vanish():
	$AnimationPlayer.play("vanish")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hobbit"):
		if visible:
			vanish()
		else:
			appear()

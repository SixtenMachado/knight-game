extends Control
class_name InspectUI

@export var se : RichTextLabel
@export var en : RichTextLabel

func _ready() -> void:
	UiManager.inspect_ui = self

func appear(speed : float = 1, warp_frequency : float = 1, warp_amplitude : float = 1, warp_speed : float = 1, warp_horizontal : float = 1, texture_override : Texture = null):
	se.material.set("shader_parameter/warp_frequency_mult", warp_frequency)
	en.material.set("shader_parameter/warp_frequency_mult", warp_frequency)
	
	se.material.set("shader_parameter/warp_amplitude_mult", warp_amplitude)
	en.material.set("shader_parameter/warp_amplitude_mult", warp_amplitude)
	
	se.material.set("shader_parameter/warp_speed", warp_speed)
	en.material.set("shader_parameter/warp_speed", warp_speed)
	
	se.material.set("shader_parameter/warp_horizontal_mult", warp_horizontal)
	en.material.set("shader_parameter/warp_horizontal_mult", warp_horizontal)
	
	if texture_override:
		$Pattern.texture = texture_override
	
	$AnimationPlayer.play("appear", -1, speed)
	
func vanish():
	$AnimationPlayer.play("vanish")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hobbit"):
		if visible:
			vanish()
		else:
			appear()
	

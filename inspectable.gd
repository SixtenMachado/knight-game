@icon("res://tools/icons/inspect.png")
extends Area3D
class_name Inspectable

@export_multiline var text_se : String
@export_multiline var text_en : String

@export var warp_frequency : float = 1.0
@export var warp_amplitude : float = 1.0
@export var warp_horizontal : float = 1.0
@export var warp_speed : float = 1.0
@export var appear_speed : float = 1.0

@export var texture_override : Texture = null

func inspected():
	var ui = UiManager.inspect_ui
	ui.se.text = text_se
	ui.en.text = text_en
	ui.appear(appear_speed, warp_frequency, warp_amplitude, warp_speed, warp_horizontal, texture_override)
	pass

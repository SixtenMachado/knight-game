@tool
class_name LightFlicker
extends Node

@export var light : Light3D

@export var energy_override : float = 1:
	set(new):
		energy_override = new
		light.light_energy = energy_override
	get:
		return energy_override

@export var floor_mult : float = 0.9
@export var min_time : float = 0.05
@export var max_time : float = 0.1
var target : float
var current : float
var t := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().process_frame
	current = light.light_energy
	target = randf_range(energy_override*floor_mult, energy_override)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current >= target:
		light.light_energy = randf_range(energy_override*floor_mult, energy_override)
		target = randf_range(min_time, max_time)
		current = 0
	else:
		current += delta
	

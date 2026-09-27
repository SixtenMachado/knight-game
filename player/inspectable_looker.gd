extends Area3D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inspect"):
		if UiManager.inspect_ui.visible:
			UiManager.inspect_ui.vanish()
		elif !get_overlapping_areas().is_empty():
			UiManager.inspect_ui.appear()

func _on_area_entered(area: Area3D) -> void:
	if area is Inspectable:
		var inspectable = area as Inspectable
		UiManager.inspect_ui.se.text = inspectable.text_se
		UiManager.inspect_ui.en.text = inspectable.text_en

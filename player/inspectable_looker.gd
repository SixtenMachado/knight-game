extends Area3D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inspect"):
		if UiManager.inspect_ui.visible:
			UiManager.inspect_ui.vanish()
		elif !get_overlapping_areas().is_empty():
			var distance: float = 100
			var inspectable
			for area in get_overlapping_areas():
				if area is Inspectable:
					var area_distance = area.global_position.distance_to(global_position)
					if area_distance < distance:
						inspectable = area
			UiManager.inspect_ui.se.text = inspectable.text_se
			UiManager.inspect_ui.en.text = inspectable.text_en
			UiManager.inspect_ui.appear()

func _on_area_entered(area: Area3D) -> void:
	return
	if area is Inspectable:
		var inspectable = area as Inspectable
		UiManager.inspect_ui.se.text = inspectable.text_se
		UiManager.inspect_ui.en.text = inspectable.text_en

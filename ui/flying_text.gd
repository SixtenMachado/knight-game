@tool
extends RichTextLabel

var fly_effect:FlyRichTextEffect

func _ready() -> void:
	# Disable clip contents or the first glyph of each line will be clipped from the left
	clip_contents = false

	fly_effect = FlyRichTextEffect.new()
	custom_effects.clear()
	install_effect(fly_effect)
	visible_ratio = 0

func _process(delta: float) -> void:
	fly_effect.delta = delta
	fly_effect.visible_characters = visible_characters
	visible_ratio += delta
	print(visible_characters)

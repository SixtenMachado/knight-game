// Text Warble GDShader Script By Matt Pin

shader_type canvas_item;

uniform float italic : hint_range(0.0, 1.0) = 0.25;

uniform float warp_frequency : hint_range(0.0, 50.0) = 15.0;
uniform float warp_frequency_mult = 1.0;
uniform float warp_amplitude : hint_range(0.0, 50.0) = 0.5;
uniform float warp_amplitude_mult = 1.0;
uniform float horizontal_warp_amplitude : hint_range(0.0, 50.0) = 0.05;
uniform float warp_horizontal_mult = 1.0;
uniform float warp_speed : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	VERTEX.y += sin(UV.x * (warp_frequency * warp_frequency_mult) + TIME * warp_speed) * (warp_amplitude * warp_amplitude_mult);
	VERTEX.x += sin(UV.y * (warp_frequency * warp_frequency_mult) + TIME * warp_speed) * (horizontal_warp_amplitude * warp_horizontal_mult);
	VERTEX.x -= (VERTEX.y * italic) - (italic * 50.0);
}
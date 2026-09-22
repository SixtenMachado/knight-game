// Text Warble GDShader Script By Matt Pin

shader_type canvas_item;

uniform float italic : hint_range(0.0, 1.0) = 0.25;

uniform float warp_frequency : hint_range(0.0, 50.0) = 15.0;
uniform float warp_amplitude : hint_range(0.0, 50.0) = 0.5;
uniform float horizontal_warp_amplitude : hint_range(0.0, 50.0) = 0.05;
uniform float warp_speed : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	VERTEX.y += sin(UV.x * warp_frequency + TIME * warp_speed) * warp_amplitude;
	VERTEX.x += sin(UV.y * warp_frequency + TIME * warp_speed) * horizontal_warp_amplitude;
	VERTEX.x -= (VERTEX.y * italic) - (italic * 50.0);
}
shader_type spatial;

render_mode blend_premul_alpha;

#include "universal_shader.gdshaderinc"

	ALPHA = texture(input_texture, squiggle_uv * uv_mult).a * adjusted_texture.a;
}

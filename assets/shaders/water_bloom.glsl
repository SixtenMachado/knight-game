#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16f, set = 0, binding = 0) uniform image2D color_image;
layout(rgba16f, set = 0, binding = 1) uniform image2D prev_frame;

layout(push_constant, std430) uniform Params {
	vec2 raster_size;

    int bands;
    float band_pixel_width;

    sampler2D t0;
    int exponential_steps;
    float curb;
    sampler2D albedo;
    float albedo_scale;
    vec2 speed;
    vec2 speed2;
    
    float _pad;
} params;

void main() {
	ivec2 texel = ivec2(gl_GlobalInvocationID.xy);
	ivec2 size = ivec2(params.raster_size);

	if (texel.x >= size.x || texel.y >= size.y) {
		return;
	}

	ivec2 size = textureSize(params.t0, 0);

    vec4 sum = vec4(0.0);
        int total_iterations = 0;
		
    for (int i = -params.bands; i <= params.bands; i++) {
        for (int j = -params.bands; j <= params.bands; j++) {
            sum += texture(params.t0, SCREEN_UV + vec2(
                (float(i) / float(size.x)) * params.band_pixel_width,
                (float(j) / float(size.y)) * params.band_pixel_width));
            total_iterations += 1;
        }
    }
    
    sum /= float(total_iterations);
	
	
	for (int n = 0; n < params.exponential_steps; ++n){
		sum += sum * sum;
	}
	
	

    COLOR = texture( t0, vec2(texel) / vec2(size) ) + (
		sum / float(bands) 
		* texture(albedo, mod((UV/params.albedo_scale) + TIME * (params.speed / params.albedo_scale), 1.0)) * texture(albedo, mod((UV/params.albedo_scale) + TIME * (params.speed2 / params.albedo_scale), 1.0)) 
		/ curb
		);

	// Write blended result to screen
	imageStore(color_image, texel, blended);
}


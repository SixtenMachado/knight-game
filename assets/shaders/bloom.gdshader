shader_type canvas_item;

uniform float strength = 20;

uniform int bands = 11;
uniform float band_pixel_width = 9.0;
uniform float division_mult = 1;

uniform sampler2D t0 : hint_screen_texture, repeat_disable, filter_nearest;

uniform int exponential_steps = 7;
uniform sampler2D albedo;
uniform float albedo_scale = 1.25;
uniform vec2 speed = vec2(0.04, 0.0);
uniform vec2 speed2 = vec2(0.0, 0.025);

// Hue is in normalized value [0.0, 1.0] where 0.0 means no change.
// For example, 0.1 shifts hue by 36° (0.1 * 360°).
uniform float hue_shift       : hint_range(-1.0, 1.0) = 0.0;
// Saturation multiplier. 1.0 means no change.
uniform float saturation_mult : hint_range(0.0, 10.0) = 1.0;
// Value (brightness in HSV) multiplier. 1.0 means no change.
uniform float value_mult      : hint_range(0.0, 100.0) = 1.0;
// Brightness addition in RGB space. 0.0 means no change.
uniform float brightness_add  : hint_range(-100.0, 100.0) = 0.0;
// Contrast multiplier in RGB space. 1.0 means no change.
uniform float contrast_mult   : hint_range(0.0, 10.0) = 1.0;

// Converts an RGB color to HSV.
vec3 rgb2hsv(vec3 c) {
    float cMax = max(max(c.r, c.g), c.b);
    float cMin = min(min(c.r, c.g), c.b);
    float delta = cMax - cMin;
    
    float h = 0.0;
    if(delta < 0.00001) {
        h = 0.0;
    } else if(cMax == c.r) {
        h = mod(((c.g - c.b) / delta), 6.0);
    } else if(cMax == c.g) {
        h = ((c.b - c.r) / delta) + 2.0;
    } else {
        h = ((c.r - c.g) / delta) + 4.0;
    }
    h /= 6.0;
    if(h < 0.0) h += 1.0;
    
    float s = (cMax <= 0.0) ? 0.0 : (delta / cMax);
    float v = cMax;
    return vec3(h, s, v);
}

// Converts an HSV color back to RGB.
vec3 hsv2rgb(vec3 c) {
    float h = c.x * 6.0;
    float s = c.y;
    float v = c.z;
    
    float c_val = v * s;
    float x = c_val * (1.0 - abs(mod(h, 2.0) - 1.0));
    vec3 rgb;
    
    if (0.0 <= h && h < 1.0) {
        rgb = vec3(c_val, x, 0.0);
    } else if (1.0 <= h && h < 2.0) {
        rgb = vec3(x, c_val, 0.0);
    } else if (2.0 <= h && h < 3.0) {
        rgb = vec3(0.0, c_val, x);
    } else if (3.0 <= h && h < 4.0) {
        rgb = vec3(0.0, x, c_val);
    } else if (4.0 <= h && h < 5.0) {
        rgb = vec3(x, 0.0, c_val);
    } else if (5.0 <= h && h < 6.0) {
        rgb = vec3(c_val, 0.0, x);
    } else {
        rgb = vec3(0.0, 0.0, 0.0);
    }
    float m = v - c_val;
    return rgb + vec3(m);
}

vec4 hsv_adjust(vec4 tex_color) {
    vec3 col = tex_color.rgb;
    
    // Adjust brightness and contrast in RGB space.
    // The contrast formula shifts the color around mid-gray (0.5).
    col = (col - 0.5) * contrast_mult + 0.5 + brightness_add;
    
    // Convert to HSV to adjust hue, saturation, and value.
    vec3 hsv = rgb2hsv(col);
    
    // Apply hue shift and wrap the value [0,1].
    hsv.x = mod(hsv.x + hue_shift, 1.0);
    
    // Adjust saturation and value multipliers.
    hsv.y *= saturation_mult;
    hsv.z *= value_mult;
    
    // Convert back to RGB.
    col = hsv2rgb(hsv);
    
    // Output the final color while preserving the original alpha.
    return vec4(col, tex_color.a);
}

void fragment() {
	ivec2 size = textureSize(t0, 0);
	
	vec4 sum = vec4(0.0);
	int total_iterations = 0;
	
	
	
    for (int i = -bands; i <= bands; i++) {
        for (int j = -bands; j <= bands; j++) {
            sum += texture(t0, SCREEN_UV + vec2(
                (float(i) / float(size.x)) * band_pixel_width,
                (float(j) / float(size.y)) * band_pixel_width));
            total_iterations += 1;
        }
    }
	
	
	sum = hsv_adjust(sum);
	
	sum /= float(total_iterations) * division_mult;
	
	if (exponential_steps > 0){
		for (int n = 0; n < exponential_steps; ++n){
			sum = sum * sum;
		}
		sum /= float(exponential_steps);
	}
		
		
	
    COLOR = texture(t0, SCREEN_UV) + (
		sum
		* texture(albedo, mod((UV/albedo_scale) + TIME * (speed / albedo_scale), 1.0)) * texture(albedo, mod((UV/albedo_scale) + TIME * (speed2 / albedo_scale), 1.0)) 
		* strength
		);
	//
}
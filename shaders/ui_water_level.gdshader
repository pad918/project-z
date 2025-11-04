shader_type canvas_item;

//
// Water level shader
// - Set `level` 0..1 (0 = empty, 1 = full)
// - Put this on a TextureRect / Sprite whose rect defines the vertical bar
//

uniform float level : hint_range(0.0,1.0) = 0.6; // fill fraction from bottom
uniform vec4 shallow_color : source_color = vec4(0.45, 0.9, 1.0, 1.0); // top (light) color
uniform vec4 deep_color    : source_color = vec4(0.02, 0.05, 0.6, 1.0); // bottom (dark) color

// wave controls
uniform float wave_amp = 0.035;     // vertical wave amplitude (in UV space)
uniform float wave_freq = 6.0;      // horizontal wave frequency
uniform float wave_speed = 0.9;     // how fast the waves move

// foam controls
uniform float foam_width = 0.03;         // thickness of foam band
uniform float foam_strength = 1.0;       // foam brightness multiplier
uniform float foam_noise_scale = 6.0;    // noise scale for foam texture
uniform float foam_noise_amp = 0.6;      // noise amplitude for foam mask

// small helper functions: value noise + fbm
float hash(vec2 p){
	return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}
float noise(vec2 p){
	vec2 i = floor(p);
	vec2 f = fract(p);
	// four corners
	float a = hash(i + vec2(0.0,0.0));
	float b = hash(i + vec2(1.0,0.0));
	float c = hash(i + vec2(0.0,1.0));
	float d = hash(i + vec2(1.0,1.0));
	// smooth interp
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
float fbm(vec2 p){
	float v = 0.0;
	float a = 0.5;
	for(int i=0;i<5;i++){
		v += a * noise(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

void fragment(){
	// uv: (0,0) top-left, (1,1) bottom-right for CanvasItem
	vec2 uv = UV;

	// compute baseline water top position in UV coordinates
	// level = 0 => y_line = 1.0 (no water); level = 1 => y_line = 0.0 (full)
	float y_line = 1.0 - clamp(level, 0.0, 1.0);

	// wave: multiple octaves via fbm for a natural crest line
	float wave_base = fbm(vec2(uv.x * wave_freq, TIME * wave_speed));
	// normalize to -1..1
	wave_base = (wave_base - 0.5) * 2.0;
	float wave = wave_base * wave_amp;

	// vertical position of the noisy/wavy top at this x
	float top_y = y_line + wave;

	// soften the top edge a bit so it blends nicely
	float edge_smooth = clamp(foam_width * 0.6, 0.001, 0.1);
	float water_mask = smoothstep(top_y - edge_smooth, top_y + edge_smooth, uv.y);
	// water_mask = 1.0 for pixels below (i.e. "inside" the water), 0.0 for pixels above

	// depth gradient from top (light) to bottom (dark) inside the water region
	// compute normalized depth inside water [0..1] where 0 at water top and 1 at bottom
	float depth_norm = 0.0;
	if (uv.y >= top_y) {
		float water_height = 1.0 - top_y;
		// avoid divide-by-zero when full (top_y==0)
		depth_norm = (water_height > 0.0001) ? clamp((uv.y - top_y) / water_height, 0.0, 1.0) : 1.0;
	}
	// slightly gamma-corrected blend so bottom feels denser
	float blend_t = pow(depth_norm, 1.2);
	vec4 base_color = mix(shallow_color, deep_color, blend_t);

	// Foam generation: concentrated near the crest (top_y) and modulated by noise
	// foam_noise gives small-scale variation to make foam "lacy"
	float fnoise = fbm(vec2(uv.x * foam_noise_scale, uv.y * foam_noise_scale + TIME * 0.2));
	// normalized foam noise
	fnoise = clamp((fnoise - 0.45) * 2.5, 0.0, 1.0);

	// foam proximity mask: strongest right at the crest, fading out above/below
	float foam_center = abs(uv.y - top_y);
	float foam_mask = smoothstep(foam_width, 0.0, foam_center); // 1 at center, 0 away
	// modulate with noise and only where water exists (so foam sits on the crest)
	foam_mask *= fnoise * foam_noise_amp * water_mask;

	// foam color (white-ish), add slight blur by using foam_mask^0.6
	vec3 foam_col = vec3(1.0, 1.0, 1.0) * pow(foam_mask, 0.8) * foam_strength;

	// combine base water color and foam; use water_mask as alpha for final compositing
	vec3 final_rgb = base_color.rgb * water_mask + foam_col;

	// final alpha: use water_mask but soften around the crest a bit
	float final_a = clamp(water_mask + foam_mask * 0.8, 0.0, 1.0);

	COLOR = vec4(final_rgb, final_a);
}

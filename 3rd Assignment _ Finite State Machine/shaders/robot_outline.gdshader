// from https://github.com/gdquest-demos/godot-shaders/blob/master/godot/Shaders/outline2D_inner_outer.shader
// MIT license
// with modifications

shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float effect_intensity : hint_range(0.0, 1.0) = 1.0;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1),
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness / 2.0;
	vec4 color = texture(TEXTURE, UV);

	float inline = 1.0;
	float outline = 0.0;
	for (int i = 0; i < OFFSETS.length(); i++) {
		float sample = texture(TEXTURE, UV + size * OFFSETS[i]).a;
		outline += sample;
		inline *= sample;
	}
	outline = min(1.0, outline) - color.a;
	inline = (1.0 - inline) * color.a;

	vec4 outlined_result = mix(color, line_color, outline + inline);

	// Apply effect intensity
	COLOR = mix(color, outlined_result, effect_intensity * outlined_result.a);
}

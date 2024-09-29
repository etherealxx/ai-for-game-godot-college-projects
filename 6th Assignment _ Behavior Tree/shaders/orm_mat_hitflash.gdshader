// 0BSD
// Copyright (C) 2024 by Etherealxx
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

// NOTE: Shader automatically converted from Godot Engine 4.3.stable's ORMMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);
uniform sampler2D texture_orm : hint_roughness_g, filter_linear_mipmap, repeat_enable;

uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16.0, 16.0);

uniform float rim : hint_range(0.0, 1.0, 0.01);
uniform float rim_tint : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_rim : hint_default_white, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform bool hit_flash_enabled = false;
uniform vec3 hit_flash_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float flashes_per_second : hint_range(0.1, 20.0) = 2.0;
uniform float emission_strength : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	vec4 orm_tex = texture(texture_orm, base_uv);
	ROUGHNESS = orm_tex.g;
 	METALLIC = orm_tex.b;

	// Normal Map: Enabled
	NORMAL_MAP = texture(texture_normal, base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;

	// Rim: Enabled
	vec2 rim_tex = texture(texture_rim, base_uv).xy;
	RIM = rim * rim_tex.x;
	RIM_TINT = rim_tint * rim_tex.y;
	
	if (hit_flash_enabled) {
		// Toggle between white and original color based on time, using mod to create a flashing effect
		bool flash_on = mod(floor(TIME * flashes_per_second), 2.0) == 0.0;

		if (flash_on) {
			ALBEDO = hit_flash_color;
			EMISSION = hit_flash_color * emission_strength;
		}
	}
}

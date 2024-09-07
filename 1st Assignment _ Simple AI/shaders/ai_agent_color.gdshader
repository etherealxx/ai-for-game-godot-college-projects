shader_type spatial;

uniform float speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    float time_factor = fract(TIME * speed);
    vec3 color = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), 1);
    ALBEDO = color;
}

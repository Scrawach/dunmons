shader_type spatial;
render_mode unshaded;

uniform sampler2D pattern;
uniform vec4 albedo_color : source_color = vec4(1, 1, 1, 1);

uniform sampler2D highlight_pattern;
uniform vec4 highlight_color : source_color = vec4(1, 1, 1, 1);
uniform float highlight_power : hint_range(1.0, 10.0, 0.1) = 1.0;
uniform float highlight_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float highlight_progress : hint_range(0.0, 1.0, 0.1) = 1.0;

void vertex() {
}

void fragment() {
	float noise = texture(pattern, UV + TIME * highlight_speed).r;
	noise = pow(noise, highlight_power);

	float rim = 1.0 - dot(NORMAL, VIEW);
	vec4 rim_color = pow(rim, highlight_power) * highlight_progress * highlight_color;

	vec4 lines_color = noise * highlight_progress * highlight_color;

	vec4 color = rim_color + lines_color + albedo_color;

	ALBEDO = vec3(color.r, color.g, color.b);
}
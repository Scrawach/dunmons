shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;
uniform float distortion_force;
uniform vec2 tiling;
uniform vec2 offset_speed;

void vertex() {
}

void fragment() {
	vec2 noise_uv = SCREEN_UV * tiling + offset_speed * TIME;
	float noise = texture(noise_texture, noise_uv).r;
	vec2 distortion_uv = UV + noise * distortion_force;
	COLOR = texture(TEXTURE, distortion_uv);
}

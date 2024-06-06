shader_type spatial;
render_mode depth_draw_always;

uniform vec3 color: source_color = vec3(1.0, 0.0, 0.0);
uniform float alpha = 0.5;

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}

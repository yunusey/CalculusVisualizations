shader_type spatial;
render_mode depth_draw_always; // gets rid of transparency issues!

uniform float alpha = 0.5;
uniform vec3 color: source_color = vec3(0.8, 0.8, 0.8);

void fragment() {
	ALPHA = alpha;
	ALBEDO = color;
}


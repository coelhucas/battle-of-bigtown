shader_type canvas_item;

uniform bool is_enabled = false;

void fragment() {
	vec4 col = texture(TEXTURE,UV);
	float grey = (col.r + col.g + col.b) * 0.333;
	
	if (is_enabled) {
		COLOR = vec4(grey, grey, grey, col.a);
	}
}
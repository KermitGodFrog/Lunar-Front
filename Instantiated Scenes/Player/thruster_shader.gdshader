shader_type spatial;
uniform sampler2D texture_source;
uniform float height;

void vertex() {
	float texture_imprint = texture(texture_source, VERTEX.xz / 2.0 + 0.5).x;
	VERTEX.y += texture_imprint * height;
}
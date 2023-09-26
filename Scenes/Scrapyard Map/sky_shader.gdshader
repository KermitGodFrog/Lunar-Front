shader_type sky;
render_mode use_half_res_pass;

uniform sampler2D source_panorama : filter_linear, source_color, hint_default_black;
uniform vec3 star_colour : source_color;

void sky() {
	float star_pos = step(0.995, EYEDIR.y);
	vec4 star = vec4(star_colour, star_pos);
	vec3 stars = texture(source_panorama, vec2(SKY_COORDS.x + TIME / 500.0, SKY_COORDS.y)).rgb;
	COLOR += stars;
	COLOR = mix(stars, star.rgb, star.a);
	COLOR += EYEDIR.y / 70.0;
}

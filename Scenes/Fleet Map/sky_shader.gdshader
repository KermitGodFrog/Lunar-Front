shader_type sky;
render_mode use_half_res_pass;

uniform sampler2D source_panorama : filter_linear, source_color, hint_default_black;
uniform vec3 planet_colour : source_color;
uniform vec3 star_colour : source_color;
uniform sampler2D ocean_noise;
uniform sampler2D cloud_noise;

void sky() {
	float planet_pos = step(0.95, EYEDIR.y);
	float star_pos = step(0.9995, EYEDIR.x);
	
	float planet_ocean;
	planet_ocean = texture(ocean_noise, EYEDIR.xz).x;
	
	float planet_clouds;
	planet_clouds = texture(cloud_noise, EYEDIR.xz + TIME / 100.0).x;
	
	vec4 planet = vec4(planet_colour, planet_pos);
	planet.b += planet_ocean;
	planet.rgb += planet_clouds / 2.0;
	
	vec4 star = vec4(star_colour, star_pos);
	vec3 stars = texture(source_panorama, vec2(SKY_COORDS.x, SKY_COORDS.y)).rgb;
	
	COLOR += stars;
	COLOR = mix(COLOR, planet.rgb, planet.a);
	COLOR = mix(COLOR, star.rgb, star.a);
	COLOR += EYEDIR.x / 70.0;
}

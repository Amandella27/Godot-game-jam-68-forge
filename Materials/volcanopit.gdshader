shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise2;

void fragment() {
	// Called for every pixel the material is visible on.
	
	
	vec4 noiseTexture = texture(noise1, UV + TIME/200.0);
	vec4 noiseTexture2 = texture(noise2, UV + TIME/200.0);
	
	float mod_color = smoothstep(0.0, 1.0, noiseTexture2.r);
	
		
	ALBEDO = vec3(noiseTexture.rgb * mod_color);
	
}

shader_type canvas_item;
render_mode blend_mix;
uniform int Type : hint_range(0,31 ) =0;
uniform sampler2D palett;
void fragment(){
	
	float tmp=(float(Type)*2.0+1.0)*(1.0/(32.0*2.0));
	vec4 tex=texture(TEXTURE,UV);

	COLOR=vec4(texture(palett,vec2(tmp,tex.r)).rgb,tex.a);
		
}
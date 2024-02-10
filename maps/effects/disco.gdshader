shader_type canvas_item;
render_mode blend_add;
uniform int Max_types=0;
uniform sampler2D palett;
void fragment(){
	float Type=float(int(TIME)%Max_types);
	float tmp=(float(Type)*2.0+1.0)*(1.0/(float(Max_types)*2.0));
	vec4 tex=texture(TEXTURE,UV);

	COLOR=vec4(texture(palett,vec2(tmp,1.0)).rgb,tex.a);
		
}
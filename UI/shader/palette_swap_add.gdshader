shader_type canvas_item;
render_mode blend_add;
uniform int Max_types=0;
uniform int Type =0;
uniform sampler2D palett:hint_default_black,filter_nearest;
void fragment(){
	float tmp=(float(Type)*2.0+1.0)*(1.0/(float(Max_types)*2.0));
	COLOR=vec4(texture(palett,vec2(tmp,COLOR.r)).rgb,COLOR.a);
		
}
shader_type canvas_item;
render_mode blend_add;
uniform int Max_types=0;
uniform int Type =0;
uniform sampler2D palett;
uniform float displacement_strength=0.0;
uniform sampler2D displacement_map: source_color;
uniform ivec2 displacement_map_size=ivec2(12,9);


void fragment(){
	ivec2 coordinates=ivec2(floor(UV*vec2(textureSize(TEXTURE,0))));
	ivec2 displacement_coordinates=ivec2(coordinates.x%displacement_map_size.x,coordinates.y%displacement_map_size.y);
	int displacement=int((texelFetch(displacement_map,displacement_coordinates,0).r-0.5)*displacement_strength);
	//vec4 fetched_texture=texelFetch(TEXTURE,coordinates+ivec2(displacement,0),0);
	vec4 fetched_texture=texelFetch(TEXTURE,ivec2(UV*vec2(textureSize(TEXTURE,0)))+ivec2(displacement,0),0);
	float tmp_color=(float(Type)*2.0+1.0)*(1.0/(float(Max_types)*2.0));
	COLOR=vec4(texture(palett,vec2(tmp_color,fetched_texture.r)).rgb,fetched_texture.a);
	//COLOR=fetched_texture;
	
	//vec2 float_coordinates=UV*TEXTURE_PIXEL_SIZE*scale;
	//ivec2 int_coordinates=round(float_coordinates);
	
}
//
//vec2 wrap_uv(vec2 input){
//	vec2 output;
//	if (input.x>1.0){
//		output.x=input.x-float(int(input.x));
//	}else{
//		output.x=input.x;
//	}
//	if (input.y>1.0){
//		output.y=input.y-float(int(input.y));
//	}else{
//		output.y=input.y;
//	}
//	return output;
//}
//
//void fragment(){
//	float tmp=(float(Type)*2.0+1.0)*(1.0/(float(Max_types)*2.0));
//	vec2 uv=UV+vec2(TEXTURE_PIXEL_SIZE.x*(texture(displacement_map,wrap_uv(vec2(UV.x,UV.y*2.0))).r-0.5)*displacement_strength,0.0);
//	vec4 tex=texture(TEXTURE,uv);
//	COLOR=vec4(texture(palett,vec2(tmp,tex.r)).rgb,tex.a);
//
//}
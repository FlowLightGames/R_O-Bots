shader_type canvas_item;
render_mode blend_add;
uniform float displacement_strength=0.0;
uniform sampler2D displacement_map: source_color;
uniform float opacity=1.0;
uniform ivec2 displacement_map_size=ivec2(12,9);


void fragment(){
	ivec2 coordinates=ivec2(floor(UV*vec2(textureSize(TEXTURE,0))));
	ivec2 displacement_coordinates=ivec2(coordinates.x%displacement_map_size.x,coordinates.y%displacement_map_size.y);
	int displacement=int((texelFetch(displacement_map,displacement_coordinates,0).r-0.5)*displacement_strength);
	//vec4 fetched_texture=texelFetch(TEXTURE,coordinates+ivec2(displacement,0),0);
	vec4 fetched_texture=texelFetch(TEXTURE,ivec2(UV*vec2(textureSize(TEXTURE,0)))+ivec2(displacement,0),0);
	//float tmp_color=(float(Type)*2.0+1.0)*(1.0/(float(Max_types)*2.0));
	COLOR=vec4(fetched_texture.rgb,fetched_texture.a*opacity);
}
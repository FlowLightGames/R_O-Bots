// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix,unshaded;
uniform int Steps=5;

void fragment(){
	vec4 tex=texture(TEXTURE,UV);
	tex.r=floor(tex.r*float(Steps))/float(Steps);
	tex.g=floor(tex.r*float(Steps))/float(Steps);
	tex.b=floor(tex.r*float(Steps))/float(Steps);
	tex.a=COLOR.a;
	COLOR=tex;
		
}
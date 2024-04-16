//---CRT Shader---
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,filter_nearest_mipmap;

uniform float vignette_intensity = 0.4;
//uniform vec4 vignette_rgb :source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform vec2 screen_size=vec2(640.0,360.0);
uniform vec2 texture_size=vec2(500.0,306.0);
uniform vec2 texture_offset=vec2(29.0,27.0);

float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 40.0;
	vignette=clamp(vignette,0.0,1.0);
	return pow(vignette, vignette_intensity );
}
vec2 uv_to_screen_uv(vec2 uv){
	uv.x=uv.x*(texture_size.x/screen_size.x);
	uv.y=uv.y*(texture_size.y/screen_size.y);
	
	uv.x=uv.x+(texture_offset.x/screen_size.x);
	uv.y=uv.y+(texture_offset.y/screen_size.y);
	return uv;
}
vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	//You can modify the numbers and try different values
	uv.x *= 1.0 + pow(abs(uv.y) / 4.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 4.0, 2.0);
	
	//The scale part (you can delete it when you want)
	//uv /= 0.5;
	
	uv = (uv/2.0) + 0.5;
	return uv;
}


void fragment()
{	
	////You can modify the *3.0, *-3.0 for a bigger or smaller 
	vec2 converted_uv=uv_curve(UV);
	//vec2 converted_uv=UV;
	converted_uv=uv_to_screen_uv(converted_uv);
	//
	//float r = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*1.0,0.0), 0.0).r;
	//float g = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*-1.0,0.0), 0.0).g;
	//float b = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*0.0,0.0), 0.0).b;
	float r = texture(SCREEN_TEXTURE, converted_uv + vec2(TEXTURE_PIXEL_SIZE.x*0.5,0.0)).r;
	float g = texture(SCREEN_TEXTURE, converted_uv + vec2(TEXTURE_PIXEL_SIZE.x*-0.5,0.0)).g;
	float b = texture(SCREEN_TEXTURE, converted_uv + vec2(TEXTURE_PIXEL_SIZE.x*0.5,0.0)).b;
	
	COLOR = vec4(r, g, b, 1.0);
	COLOR=COLOR*1.1;
	COLOR.rgb*=floor((pow(vignette(UV),50.0))*16.0)/16.0;
	//COLOR=texture(SCREEN_TEXTURE,UV);
	//COLOR=vec4(1.0,1.0,1.0,1.0);
	//COLOR.rgb=COLOR.rgb*texture(SCREEN_TEXTURE,UV).rgb;
}

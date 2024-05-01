//---CRT Shader---
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,repeat_disable,filter_nearest;
uniform sampler2D scanline_tex:repeat_enable,filter_nearest;

uniform float noise_strength=0.3;
uniform float scanline_strength=0.5;
uniform float vignette_intensity = 0.4;
uniform float warp_intensity_x=4.0;
uniform float warp_intensity_y=4.0;
//uniform vec4 vignette_rgb :source_color = vec4(0.0, 0.0, 0.0, 1.0);

float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * 40.0;
	vignette=clamp(vignette,0.0,1.0);
	return pow(vignette, vignette_intensity );
}
//vec2 uv_to_screen_uv(vec2 uv){
	//uv.x=uv.x*(texture_size.x/screen_size.x);
	//uv.y=uv.y*(texture_size.y/screen_size.y);
	//
	//uv.x=uv.x+(texture_offset.x/screen_size.x);
	//uv.y=uv.y+(texture_offset.y/screen_size.y);
	//return uv;
//}
vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	//You can modify the numbers and try different values
	uv.x *= 1.0 + pow(abs(uv.y) / warp_intensity_y, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / warp_intensity_x, 2.0);
	
	//The scale part (you can delete it when you want)
	//uv /= 0.5;
	
	uv = (uv/2.0) + 0.5;
	return uv;
}
float random(vec2 uv){
	return fract(sin(dot(uv,vec2(12.9898,78.233)))*43758.5453);
}

void fragment()
{	
	////You can modify the *3.0, *-3.0 for a bigger or smaller 
	//vec2 converted_uv=uv_curve(UV);
	vec2 converted_uv=UV;
	//float crt_mask=0.0;
	//if (converted_uv.x<=1.0&&converted_uv.x>=0.0&&converted_uv.y<=1.0&&converted_uv.y>=0.0){
		//crt_mask=1.0;
	//}
	vec4 scanline=texture(scanline_tex,UV);
	vec2 noise_pixel=vec2(floor((SCREEN_UV.x/SCREEN_PIXEL_SIZE.x)/3.0)*3.0,SCREEN_UV.y);
	float white_noise=random(noise_pixel+vec2(sin(TIME*PI/4.0),cos(TIME*PI/8.0)));
	float r = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*+0.25,0.0)).r;
	float g = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*-0.25,0.0)).g;
	float b = texture(SCREEN_TEXTURE, converted_uv + vec2(SCREEN_PIXEL_SIZE.x*0.0,0.0)).b;
	
	COLOR = vec4(r, g, b, 1.0);
	COLOR=COLOR*1.1;
	//COLOR.rgb*=floor((pow(vignette(UV),50.0))*16.0)/16.0;
	COLOR.rgb*=(pow(vignette(UV),50.0));
	COLOR.rgb=mix(COLOR.rgb,vec3(white_noise),noise_strength);
	COLOR.rgb=mix(COLOR.rgb,scanline.rgb,scanline_strength*scanline.a);
	COLOR.rgb+=vec3(0.05,0.05,0.05);
	//COLOR.rgb*=1.1;
	//COLOR*=crt_mask;
	//COLOR.a=1.0;
	//COLOR=texture(SCREEN_TEXTURE,UV);
	//COLOR=vec4(1.0,1.0,1.0,1.0);
	//COLOR.rgb=COLOR.rgb*texture(SCREEN_TEXTURE,UV).rgb;
}
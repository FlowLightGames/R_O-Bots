shader_type canvas_item;

uniform float scan_line_count : hint_range(0, 1480) = 50.0;

vec2 uv_curve(vec2 uv) {
	
	uv = (uv - 0.5) * 2.0;
	uv.x *= 1.0 + pow(abs(uv.y) / 8.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 6.0, 2.0);
//	uv.x *= 1.0 + pow(abs(uv.y) / 8.0, 2.0);
//	uv.y *= 1.0 + pow(abs(uv.x) / 4.5, 2.0);
	uv = (uv / 2.0) + 0.5;
	return uv;
}

void fragment() {
	float PI = 3.14159;
	
	ivec2 siz= textureSize ( SCREEN_TEXTURE, 0 );
	ivec2 tmp=ivec2(int(float(siz.x)*(uv_curve(SCREEN_UV)).x),int(float(siz.y)*(uv_curve(SCREEN_UV)).y));
	
	float r =texelFetch(SCREEN_TEXTURE, tmp+ivec2(-1,0), 0).r;
	float g =texelFetch(SCREEN_TEXTURE, tmp+ivec2(0,0), 0).g;
	float b =texelFetch(SCREEN_TEXTURE, tmp+ivec2(0,0), 0).b;
	
	float s = 0.0;
	
	s = sin(UV.y * scan_line_count * PI * 2.0);
	
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	vec4 scan_line = vec4(1.1*vec3(pow(s, 0.25)), 1.0);
	
	COLOR = vec4(r,g,b,1.0) * scan_line;
}
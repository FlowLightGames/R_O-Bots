shader_type canvas_item;
//render_mode blend_add;
uniform sampler2D post_tex:hint_default_black,filter_nearest;
uniform int steps=3;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb=texture(post_tex,vec2(COLOR.r,0.5)).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

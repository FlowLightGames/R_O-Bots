shader_type canvas_item;
render_mode blend_mix;
uniform sampler2D palett : hint_white;
uniform int Type :  hint_range(0,5 ) =0;
uniform int particles_anim_h_frames;
uniform int particles_anim_v_frames;
uniform bool particles_anim_loop;
void vertex() {
	float h_frames = float(particles_anim_h_frames);
	float v_frames = float(particles_anim_v_frames);
	VERTEX.xy /= vec2(h_frames, v_frames);
	float particle_total_frames = float(particles_anim_h_frames * particles_anim_v_frames);
	float particle_frame = floor(INSTANCE_CUSTOM.z * float(particle_total_frames));
	if (!particles_anim_loop) {
		particle_frame = clamp(particle_frame, 0.0, particle_total_frames - 1.0);
	} else {
		particle_frame = mod(particle_frame, particle_total_frames);
	}	UV /= vec2(h_frames, v_frames);
	UV += vec2(mod(particle_frame, h_frames) / h_frames, floor(particle_frame / h_frames) / v_frames);

}
void fragment(){
	float tmp=(float(Type)*2.0+1.0)*(1.0/(6.0*2.0));
	vec4 tex=texture(TEXTURE,UV);
	COLOR=vec4(texture(palett,vec2(tmp,tex.r)).rgb,tex.a);
}

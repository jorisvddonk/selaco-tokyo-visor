vec3 rgb2hsv(vec4 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void main()
{
	const float factor = 0.35;
	const float mfactor = 2.5;
	vec4 outC = texture(InputTexture, TexCoord);
	bool is_motion = false;

	vec3 h = rgb2hsv(outC);
	if (h.x >= 0.25 && h.x <= 0.40 && h.z > 0.15 && h.y > 0.35) {
		is_motion = true;
	}

	vec2 coord = TexCoord * 32.0;
	vec2 tc;
	tc.x = coord.x * cos(timer) - coord.y * sin(timer);
	tc.y = coord.x * sin(timer) + coord.y * cos(timer);
	if (is_motion) { // make white if motion detected
		outC = vec4(outC.g*mfactor, outC.g*mfactor, outC.g*mfactor, 1.0);
		outC = mix(outC, texture(NoiseTexture, tc), 0.1); // add tiny bit of noise
	} else { // make noisy if no motion detected
		outC = mix(outC, texture(NoiseTexture, tc), 0.3); // add noise
		const vec3 W = vec3(0.2125, 0.7154, 0.0721); // luminance in sRGB color space
		float f = dot(outC.rgb, W);
		outC = vec4(f*factor, f*factor, f*factor, 1.0);
	}
	FragColor = outC;
}

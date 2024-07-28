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
	const float factor = 0.75;
	bool is_therm = false;
	vec4 outC = texture(InputTexture, TexCoord);

	vec3 h = rgb2hsv(outC);
	if (h.x >= 0.13 && h.x <= 0.20 && h.z > 0.35 && h.y > 0.35) {
		is_therm = true;
	}

	vec2 coord = TexCoord * 32.0;
	vec2 tc;
	tc.x = coord.x * cos(timer) - coord.y * sin(timer);
	tc.y = coord.x * sin(timer) + coord.y * cos(timer);
	outC = mix(outC, texture(NoiseTexture, tc), 0.3);
	const vec3 W = vec3(0.2125, 0.7154, 0.0721); // luminance in sRGB color space
	float f = dot(outC.rgb, W);
	if (!is_therm) { // make purple if not thermal signature detected
		outC = vec4(f*0.8*factor, f*0.3*factor, f*0.7*factor, 1.0);
	}
	FragColor = outC;
}

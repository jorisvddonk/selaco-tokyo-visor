void main()
{
	const float afactor = 0.03;
	const float mfactor = 3.0;
	vec4 outC = texture(InputTexture, TexCoord);
	vec2 coord = TexCoord * 32.0;
	vec2 tc;
	tc.x = coord.x * cos(timer) - coord.y * sin(timer);
	tc.y = coord.x * sin(timer) + coord.y * cos(timer);
	outC = mix(outC, texture(NoiseTexture, tc), 0.05);
	const vec3 W = vec3(0.2125, 0.7154, 0.0721); // luminance in sRGB color space
	float f = dot(outC.rgb, W);
	outC = vec4((f+afactor)*mfactor, (f+afactor)*mfactor, (f+afactor)*mfactor, 1.0);
	FragColor = outC;
}

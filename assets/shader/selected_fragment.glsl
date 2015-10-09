#version 330 core
// layout (location = 0) out vec4 gLight;
layout (location = 0) out vec3 gLight;

in vec3 FragPos;
in vec3 MeanFragPos;
in vec3 Normal;

void main()
{
	gLight = vec3(0.0, 1.0, 0.0);
	// gLight = vec4(0.0, 1.0, 0.0, 1.0);
	// float linearZ = (2.0 * gl_FragCoord.z - gl_DepthRange.near - gl_DepthRange.far) /
	// 	(gl_DepthRange.far - gl_DepthRange.near);
	
	// gLight = vec4(linearZ, linearZ, linearZ, 1.0);
}
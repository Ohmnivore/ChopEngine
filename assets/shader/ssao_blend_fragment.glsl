#version 330 core

in vec2 UV;

layout (location = 0) out vec4 color;

uniform sampler2D gForwardLight;
uniform sampler2D gSSAO;

void main()
{
	vec4 actual = texture(gForwardLight, UV);
	float occlusion = texture(gSSAO, UV).x;
	
	color = actual * occlusion * occlusion;
	// color = vec4(occlusion, occlusion, occlusion, 1.0f);
	// color = vec3(1.0, 1.0, 0.0);
}

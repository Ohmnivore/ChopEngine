#version 330 core

uniform sampler2D renderedTexture;

in vec2 UV;

out vec4 color;

void main()
{
	vec3 texColor = texture(renderedTexture, UV).xyz;
	
	color = vec4(texColor.rgb, dot(texColor.rgb, vec3(0.299, 0.587, 0.114)));
}
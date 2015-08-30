#version 330 core

in vec2 UV;

layout (location = 0) out vec3 color;

uniform sampler2D renderedTexture;

void main()
{
	color = texture(renderedTexture, UV).xyz;
	// color = vec3(1.0, 1.0, 0.0);
}

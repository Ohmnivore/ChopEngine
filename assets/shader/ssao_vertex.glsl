#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPositionModelSpace;

// Output data ; will be interpolated for each fragment.
out vec2 TexCoords;

void main()
{
	gl_Position =  vec4(vertexPositionModelSpace, 1.0f);
	TexCoords = (vertexPositionModelSpace.xy + vec2(1.0f, 1.0f)) / 2.0f;
}

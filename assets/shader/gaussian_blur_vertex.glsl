#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertexPositionModelSpace;

// Output data ; will be interpolated for each fragment.
out vec2 vertTexCoord;

void main()
{
	gl_Position =  vec4(vertexPositionModelSpace, 1);
	vertTexCoord = (vertexPositionModelSpace.xy + vec2(1, 1)) / 2.0;
}

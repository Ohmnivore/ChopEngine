#version 100

attribute vec3 positionModelSpace;

uniform mat4 mvp;

void main()
{
	gl_Position = mvp * vec4(positionModelSpace, 1);
}

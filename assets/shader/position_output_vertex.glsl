#version 330 core
layout (location = 0) in vec3 position;

out vec3 FragPos;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;

void main()
{
	vec4 viewPos = v * m * vec4(position, 1.0f);
    FragPos = viewPos.xyz; 
    gl_Position = p * viewPos;
}
#version 330 core
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec3 Normal;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;

void main()
{
	gl_Position = p * v * m * vec4(position, 1.0f);
	
    mat3 normalMatrix = transpose(inverse(mat3(v * m)));
    Normal = normalMatrix * normal;
}
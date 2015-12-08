#version 330 core
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec4 uv;

out vec3 FragPos;
out vec3 Normal;
out vec4 UV;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;

void main()
{
    vec4 worldPos = m * vec4(position, 1.0f);
    FragPos = worldPos.xyz;
    gl_Position = p * v * worldPos;
    
    mat3 normalMatrix = transpose(inverse(mat3(m)));
    Normal = normalize(normalMatrix * normal);
	
	UV = uv;
}
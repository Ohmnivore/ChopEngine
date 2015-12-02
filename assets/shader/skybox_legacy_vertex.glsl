#version 330 core
layout (location = 0) in vec3 position;
layout (location = 1) in vec2 uv;
out vec2 TexCoords;

uniform mat4 projection;
uniform mat4 view;


void main()
{
    gl_Position = projection * mat4(mat3(view)) * vec4(position, 1.0);
    //gl_Position = projection * view * vec4(position, 1.0);
    TexCoords = uv;
}
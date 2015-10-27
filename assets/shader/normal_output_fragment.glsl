#version 330 core
out vec3 color;

in vec3 Normal;

void main()
{
    color = normalize(Normal);
}
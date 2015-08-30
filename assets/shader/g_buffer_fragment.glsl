#version 330 core
layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec3 gDiffuse;
layout (location = 3) out vec3 gSpec;

in vec3 FragPos;
in vec3 Normal;

uniform vec3 diffuseColor;
uniform vec3 specularColor;

void main()
{
    gPosition = FragPos;
    gNormal = normalize(Normal);
    gDiffuse = diffuseColor;
    gSpec = specularColor;
}
#version 330 core
layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec4 gNormal;
layout (location = 2) out vec4 gDiffuse;
layout (location = 3) out vec4 gSpec;

in vec3 FragPos;
in vec3 MeanFragPos;
in vec3 Normal;

uniform vec3 diffuseColor;
uniform float diffuseIntensity;
uniform vec3 specularColor;
uniform float specularIntensity;
uniform float ambientIntensity;
uniform float emit;
uniform float materialFlags;

void main()
{
    gPosition = MeanFragPos;
    gNormal = vec4(normalize(Normal), ambientIntensity);
    gDiffuse = vec4(diffuseColor * diffuseIntensity, materialFlags);
    gSpec = vec4(specularColor * specularIntensity, emit);
}
#version 330 core
layout (location = 0) out vec4 gPosition;
layout (location = 1) out vec4 gNormal;
layout (location = 2) out vec4 gDiffuse;
layout (location = 3) out vec4 gSpec;
layout (location = 4) out vec4 gRealPosition;

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

const float NEAR = 0.1;
const float FAR = 50.0f;
float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // Back to NDC 
    return (2.0 * NEAR * FAR) / (FAR + NEAR - z * (FAR - NEAR));	
}
float MyLinearizeDepth(float depth)
{
    return depth * 2.0 - 1.0; // Back to NDC 
}

void main()
{
    gRealPosition = vec4(FragPos, LinearizeDepth(gl_FragCoord.z));
    gPosition = vec4(MeanFragPos, LinearizeDepth(gl_FragCoord.z));
    // gPosition = vec4(MeanFragPos, gl_FragCoord.z);
    // gPosition = vec4(MeanFragPos, MyLinearizeDepth(gl_FragCoord.z));
    gNormal = vec4(normalize(Normal), ambientIntensity);
    gDiffuse = vec4(diffuseColor * diffuseIntensity, materialFlags);
    gSpec = vec4(specularColor * specularIntensity, emit);
}
#version 330 core
layout (location = 0) out vec4 gPosition;
layout (location = 1) out vec4 gNormal;
layout (location = 2) out vec4 gDiffuse;
layout (location = 3) out vec4 gSpec;
layout (location = 4) out vec4 gRealPosition;
layout (location = 5) out vec4 gUV;

in vec3 FragPos;
in vec3 MeanFragPos;
in vec3 Normal;
in vec3 UV;

uniform vec3 diffuseColor;
uniform float diffuseIntensity;
uniform vec3 specularColor;
uniform float specularIntensity;
uniform float ambientIntensity;
uniform float emit;
uniform float materialFlags;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D texture4;
uniform sampler2D texture5;
uniform sampler2D texture6;
uniform sampler2D texture7;
uniform sampler2D texture8;
uniform sampler2D texture9;
uniform sampler2D texture10;
uniform sampler2D texture11;
uniform sampler2D texture12;
uniform sampler2D texture13;
uniform sampler2D texture14;
uniform sampler2D texture15;

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

vec4 getTextureValue(vec2 uv, int tID)
{
	if (tID == 0)
		return texture(texture0, uv);
	return vec4(1.0, 0.0, 1.0, 1.0);
}

void main()
{
	int textureID = int(UV.z * 16.0);
	if (textureID < 0)
		gDiffuse = vec4(diffuseColor * diffuseIntensity, materialFlags);
	else
	{
		vec4 texDiffuse = getTextureValue(UV.xy, textureID);
		gDiffuse = texDiffuse * texDiffuse.w + vec4(diffuseColor.xyz, 1.0) * (1.0 - texDiffuse.w);
	}
	
    gRealPosition = vec4(FragPos, LinearizeDepth(gl_FragCoord.z));
    gPosition = vec4(MeanFragPos, LinearizeDepth(gl_FragCoord.z));
    // gPosition = vec4(MeanFragPos, gl_FragCoord.z);
    // gPosition = vec4(MeanFragPos, MyLinearizeDepth(gl_FragCoord.z));
    gNormal = vec4(normalize(Normal), ambientIntensity);
    gSpec = vec4(specularColor * specularIntensity, emit);
	gUV = vec4(UV.xyz, 1.0);
}
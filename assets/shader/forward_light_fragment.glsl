#version 330 core

in vec3 FragPos;
in vec3 MeanFragPos;
in vec3 Normal;
in vec3 UV;

out vec4 color;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;
uniform vec3 viewPos;
uniform vec3 ambientColor;
uniform float ambientIntensity;
uniform float gamma;

// material info
struct Material
{
    bool useShading;
    bool shadowsCast;
    bool shadowsReceive;
    vec3 diffuseColor;
    float diffuseIntensity;
    vec3 specularColor;
    float specularIntensity;
    float ambientIntensity;
    float emit;
    float transparency;
};
uniform Material material;

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

// lights info
#define MAX_LIGHTS 32
uniform int numLights;
struct Light
{
    int type;
    vec3 position;
    vec3 direction;
    float energy;
    vec3 color;
    float distance;
    bool useSpecular;
    bool useDiffuse;
    float coneAngle;
};
uniform Light allLights[MAX_LIGHTS];

vec4 getTextureValue(vec2 uv, int tID)
{
	if (tID == 0) return texture(texture0, uv);
	if (tID == 1) return texture(texture1, uv);
	if (tID == 2) return texture(texture2, uv);
	if (tID == 3) return texture(texture3, uv);
	if (tID == 4) return texture(texture4, uv);
	if (tID == 5) return texture(texture5, uv);
	if (tID == 6) return texture(texture6, uv);
	if (tID == 7) return texture(texture7, uv);
	if (tID == 8) return texture(texture8, uv);
	if (tID == 9) return texture(texture9, uv);
	if (tID == 10) return texture(texture10, uv);
	if (tID == 11) return texture(texture11, uv);
	if (tID == 12) return texture(texture12, uv);
	if (tID == 13) return texture(texture13, uv);
	if (tID == 14) return texture(texture14, uv);
	if (tID == 15) return texture(texture15, uv);
	return vec4(1.0, 0.0, 1.0, 1.0);
}

void main()
{
	// int textureID = int(UV.z * 16.0);
	// if (textureID < 0)
		// gDiffuse = vec4(material.diffuseColor * material.diffuseIntensity, material.transparency);
	// else
	// {
	// 	vec4 texDiffuse = getTextureValue(UV.xy, textureID);
	// 	gDiffuse = texDiffuse * texDiffuse.w + vec4(diffuseColor.xyz, 1.0) * (1.0 - texDiffuse.w);
	// 	gDiffuse.w = material.transparency;
	// }
	
	float alpha = material.transparency;
	vec3 Diffuse = material.diffuseColor * material.diffuseIntensity;
	vec3 Specular = material.specularColor * material.specularIntensity;
	vec3 Normal = Normal;
	
	int textureID = int(UV.z * 16.0);
	if (textureID >= 0)
	{
	   vec4 texDiffuse = getTextureValue(UV.xy, textureID);
	   Diffuse = vec3(texDiffuse.xyz) * texDiffuse.w + Diffuse.xyz * (material.transparency - texDiffuse.w);
	   // alpha = texDiffuse.w;
	}
	
	// Decode the G Buffer
	// vec3 FragPos = texture(gPosition, UV).rgb;
	// vec3 FragRealPos = texture(gRealPosition, UV).rgb;
    // vec3 Normal = texture(gNormal, UV).rgb;
    // vec3 Diffuse = texture(gDiffuse, UV).rgb;
    // vec3 Specular = texture(gSpec, UV).rgb;
	// float MaterialFlags = texture(gDiffuse, UV).a;
	// float AmbientIntensity = texture(gNormal, UV).a;
	// float Emit = texture(gSpec, UV).a;
	// Material material = createMaterial(MaterialFlags, Diffuse, Specular, AmbientIntensity, Emit);
	
	vec3 linearColor = vec3(0);

    if (material.useShading)
    {
		vec3 viewDir = normalize(viewPos - MeanFragPos);
		
        for (int i = 0; i < numLights; ++i)
        {
			Light light = allLights[i];
			
			// Calculate distance between light source and current fragment
			float distance = length(light.position - MeanFragPos);
			float realDistance = length(light.position - FragPos);
			
			if (light.type != 0)
				// Don't check distance for sun lights
				if (realDistance > light.distance)
					continue;
			
			// Diffuse
			vec3 lightDir;
			if (light.type == 0)
				// Sun light direction is constant
				lightDir = -light.direction;
			else
				lightDir = normalize(light.position - MeanFragPos);
			vec3 diffuse = vec3(0);
			if (light.useDiffuse)
				diffuse = max(dot(Normal, lightDir), 0.0) * Diffuse * light.color;
			
			// Specular
			vec3 halfwayDir = normalize(lightDir + viewDir);
			vec3 specular = vec3(0);
			if (light.useSpecular)
			{
				float spec = pow(max(dot(Normal, halfwayDir), 0.0), 16.0);
				specular = light.color * spec * Specular;
			}
			
			// Attenuation
			float attenuation = 1.0;
			if (light.type != 0)
				attenuation = 1.0 / (distance * distance);
			
			// Cone light attenuation
			if (light.type == 2)
			{
				// 1. Get the direction for the center of the cone. The `normalize`
				//    function is called just in case `light.coneDirection` isn't
				//    already a unit vector.
				vec3 coneDirection = normalize(light.direction);

				// 2. Get the direction of the ray of light. This is the opposite
				//    of the direction from the surface to the light.
				vec3 rayDirection = -normalize(light.position - FragPos);

				// 3. Get the angle between the center of the cone and the ray of light.
				//    The combination of `acos` and `dot` return the angle in radians, then
				//    we convert it to degrees.
				float lightToSurfaceAngle = degrees(acos(dot(rayDirection, coneDirection)));

				// 4. Check if the angle is outside of the cone. If so, set the attenuation
				//    factor to zero, to make the light ray invisible.
				if (lightToSurfaceAngle > light.coneAngle)
				{
					attenuation = 0.0;
				}
			}
			
			diffuse *= attenuation;
			specular *= attenuation;
			
			linearColor += (diffuse + specular) * light.energy * 100.0;
        }
        // Emit
        linearColor += material.diffuseColor * material.emit;
        // Ambient : simulates indirect lighting
        linearColor += ambientColor * material.ambientIntensity * ambientIntensity;
    }
    else
    {
        linearColor = Diffuse;
    }

    // gamma correction
    vec3 gammav = vec3(gamma);
    color = vec4(pow(linearColor, gammav), alpha);
	
	// Ugly hack to keep the optimizer from removing supposedly unused uniforms
	color.x += float(material.shadowsCast) * 0.00001;
	color.x += float(material.shadowsReceive) * 0.00001;
}
#version 330 core

in vec2 UV;

out vec4 color;

uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D gDiffuse;
uniform sampler2D gSpec;
uniform sampler2D gRealPosition;

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

bool getFlagAsBool(int flags, int flag)
{
	return (flags & flag) != 0;
}
Material createMaterial(float flags, vec3 diffuseColor, vec3 specularColor, float ambientIntensity, float emit)
{
	int intFlags = int(flags * 7.0);
	return Material(getFlagAsBool(intFlags, 0x01), getFlagAsBool(intFlags, 0x02), getFlagAsBool(intFlags, 0x04), diffuseColor, 1.0, specularColor, 1.0, ambientIntensity, emit, 1.0);
}

void main()
{
	// Decode the G Buffer
	vec3 FragPos = texture(gPosition, UV).rgb;
	vec3 FragRealPos = texture(gRealPosition, UV).rgb;
    vec3 Normal = texture(gNormal, UV).rgb;
    vec3 Diffuse = texture(gDiffuse, UV).rgb;
    vec3 Specular = texture(gSpec, UV).rgb;
	float MaterialFlags = texture(gDiffuse, UV).a;
	float AmbientIntensity = texture(gNormal, UV).a;
	float Emit = texture(gSpec, UV).a;
	Material material = createMaterial(MaterialFlags, Diffuse, Specular, AmbientIntensity, Emit);
	
	vec3 linearColor = vec3(0);

    if (material.useShading)
    {
		vec3 viewDir = normalize(viewPos - FragPos);
		
        for (int i = 0; i < numLights; ++i)
        {
			Light light = allLights[i];
			
			// Calculate distance between light source and current fragment
			float distance = length(light.position - FragPos);
			float realDistance = length(light.position - FragRealPos);
			
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
				lightDir = normalize(light.position - FragPos);
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
				vec3 rayDirection = -normalize(light.position - FragRealPos);

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
    color = vec4(pow(linearColor, gammav), texture(gPosition, UV).a);
	
	// Ugly hack to keep the optimizer from removing supposedly unused uniforms
	// Ensure material uniform compilation
	color.x += float(material.shadowsCast) * 0.00001;
	color.x += float(material.shadowsReceive) * 0.00001;
}
precision mediump float;

varying vec3 FragPos;
varying vec3 MeanFragPos;
varying vec3 Normal;
varying vec3 UV;

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

// vec4 getTextureValue(vec2 uv, int tID)
// {
// 	if (tID == 0)
// 		return texture(texture0, uv);
// 	return vec4(1.0, 0.0, 1.0, 1.0);
// }

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
	
	vec3 Diffuse = material.diffuseColor * material.diffuseIntensity;
	vec3 Specular = material.specularColor * material.specularIntensity;
	vec3 Normal = Normal;
	
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

        linearColor = Diffuse;

    // gamma correction
    vec3 gammav = vec3(gamma);
    gl_FragColor = vec4(pow(linearColor, gammav), material.transparency);
	
	// Ugly hack to keep the optimizer from removing supposedly unused uniforms
	gl_FragColor.x += float(material.shadowsCast) * 0.00001;
	gl_FragColor.x += float(material.shadowsReceive) * 0.00001;
}
#version 100

precision mediump float;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;
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

vec3 applyLight(Light light, Material mat, vec3 lMeanPositionModelSpace, vec3 lMeanNormalModelSpace)
{
    // Position of the vertex, in worldspace : M * position
    vec3 positionWorldSpace = (m * vec4(lMeanPositionModelSpace, 1)).xyz;

    // Vector that goes from the vertex to the camera, in camera space.
    // In camera space, the camera is at the origin (0,0,0).
    vec3 vertexPositionCameraSpace = (v * m * vec4(lMeanPositionModelSpace, 1)).xyz;
    vec3 eyeDirectionCameraSpace = vec3(0, 0, 0) - vertexPositionCameraSpace;

    // Distance to the light
    float distance = length(light.position - positionWorldSpace);

    // Vector that goes from the vertex to the light, in camera space. M is ommited because it's identity.
    vec3 lightPositionCameraSpace = (v * vec4(light.position, 1)).xyz;
    vec3 lightDirectionCameraSpace;
    if (light.type == 0)
    {
        lightDirectionCameraSpace = -light.direction;
    }
    else
    {
        lightDirectionCameraSpace = lightPositionCameraSpace + eyeDirectionCameraSpace;
        if (distance > light.distance)
        {
            return vec3(0, 0, 0);
        }
    }

    // Normal of the the vertex, in camera space
    vec3 normalCameraSpace = (v * m * vec4(lMeanNormalModelSpace, 0)).xyz; // Only correct if ModelMatrix does not scale the model ! Use its inverse transpose if not.


    // Light emission properties
    float lightPower = light.energy * 100.0;

    if (light.type == 2)
    {
        // 1. Get the direction for the center of the cone. The `normalize`
        //    function is called just in case `light.coneDirection` isn't
        //    already a unit vector.
        vec3 coneDirection = normalize(light.direction);

        // 2. Get the direction of the ray of light. This is the opposite
        //    of the direction from the surface to the light.
        vec3 rayDirection = -lightDirectionCameraSpace;

        // 3. Get the angle between the center of the cone and the ray of light.
        //    The combination of `acos` and `dot` return the angle in radians, then
        //    we convert it to degrees.
        float lightToSurfaceAngle = degrees(acos(dot(rayDirection, coneDirection)));

        // 4. Check if the angle is outside of the cone. If so, set the attenuation
        //    factor to zero, to make the light ray invisible.
        if (lightToSurfaceAngle > light.coneAngle)
        {
            lightPower = 0.0;
        }
        // distanceMod = 1.0 / (distance * distance);
        // lightPower *= max(0.0, 1.0 - abs(lightToSurfaceAngle / light.coneAngle));
        // lightPower = 1.0 / pow(lightToSurfaceAngle, 2);
    }

    // Normal of the computed fragment, in camera space
    vec3 n = normalize(normalCameraSpace);
    // Direction of the light (from the fragment to the light)
    vec3 l = normalize(lightDirectionCameraSpace);
    // Cosine of the angle between the normal and the light direction,
    // clamped above 0
    //  - light is at the vertical of the triangle -> 1
    //  - light is perpendicular to the triangle -> 0
    //  - light is behind the triangle -> 0
    float cosTheta = clamp(dot(n, l), 0.0, 1.0);

    // Eye vector (towards the camera)
    vec3 E = normalize(eyeDirectionCameraSpace);
    // Direction in which the triangle reflects the light
    vec3 R = reflect(-l, n);
    // Cosine of the angle between the Eye vector and the Reflect vector,
    // clamped to 0
    //  - Looking into the reflection -> 1
    //  - Looking elsewhere -> < 1
    float cosAlpha = clamp(dot(E, R), 0.0, 1.0);

    float distanceMod;
    if (light.type == 0)
    {
        distanceMod = 1.0;
    }
    else
    {
        distanceMod = 1.0 / (distance * distance);
    }

    if (!light.useDiffuse)
        cosTheta = 0.0;
    if (!light.useSpecular)
        cosAlpha = 0.0;

    return vec3(
        // Diffuse : "color" of the object
        mat.diffuseColor * light.color * mat.diffuseIntensity * lightPower * cosTheta * distanceMod +
        // Specular : reflective highlight, like a mirror
        mat.specularColor * light.color * mat.specularIntensity * lightPower * pow(cosAlpha, 5.0) * distanceMod
        );
}

void main()
{
    // gl_FragColor = vec4(pow(linearColor, gammav), material.transparency);
    gl_FragColor = vec4(material.diffuseColor.xyz, material.transparency);
    // color = vec4(material.diffuseColor.xyz, material.transparency);
    // color = vec4(inMeanPositionModelSpace.xyz, material.transparency);
	
	// Ensure input compilation
	// gl_FragColor.x += inPositionModelSpace.x * 0.00001;
	// gl_FragColor.x += inNormalModelSpace.x * 0.00001;
	// gl_FragColor.x += inMeanPositionModelSpace.x * 0.00001;
	// gl_FragColor.x += inMeanNormalModelSpace.x * 0.00001;
	
	// Ensure material uniform compilation
	gl_FragColor.x += material.diffuseColor.x * 0.00001;
	gl_FragColor.x += material.diffuseIntensity * 0.00001;
	gl_FragColor.x += material.specularColor.x * 0.00001;
	gl_FragColor.x += material.specularIntensity * 0.00001;
	gl_FragColor.x += material.ambientIntensity * 0.00001;
	gl_FragColor.x += material.emit * 0.00001;
	gl_FragColor.x += material.transparency * 0.00001;
	gl_FragColor.x += float(material.useShading) * 0.00001;
	gl_FragColor.x += float(material.shadowsCast) * 0.00001;
	gl_FragColor.x += float(material.shadowsReceive) * 0.00001;
	
	// Ensure misc uniform compilation
	gl_FragColor.x += float(numLights) * 0.00001;
	gl_FragColor.x += m[0][0] * 0.00001;
	gl_FragColor.x += v[0][0] * 0.00001;
	gl_FragColor.x += p[0][0] * 0.00001;
	gl_FragColor.x += ambientColor.x * 0.00001;
	gl_FragColor.x += ambientIntensity * 0.00001;
	gl_FragColor.x += gamma * 0.00001;
	
	// Ensure lights uniform compilation
	gl_FragColor.x += float(allLights[0].useSpecular) * 0.00001;
	gl_FragColor.x += float(allLights[0].useDiffuse) * 0.00001;
	gl_FragColor.x += float(allLights[0].type) * 0.00001;
	gl_FragColor.x += allLights[0].energy * 0.00001;
	gl_FragColor.x += allLights[0].color.x * 0.00001;
	gl_FragColor.x += allLights[0].distance * 0.00001;
	if (allLights[0].type == 0 || allLights[0].type == 2)
		gl_FragColor.x += allLights[0].direction.x * 0.00001;
	if (allLights[0].type == 1 || allLights[0].type == 2)
		gl_FragColor.x += allLights[0].position.x * 0.00001;
	if (allLights[0].type == 2)
		gl_FragColor.x += allLights[0].coneAngle * 0.00001;
}

#version 330 core
out vec4 gPositionDepth;

in vec3 FragPos;

const float NEAR = 0.1;
const float FAR = 200.0f;
float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // Back to NDC 
    return (2.0 * NEAR * FAR) / (FAR + NEAR - z * (FAR - NEAR));	
}

void main()
{    
    // Store the fragment position vector in the first gbuffer texture
    gPositionDepth.xyz = FragPos;
    // And store linear depth into gPositionDepth's alpha component
    gPositionDepth.a = LinearizeDepth(gl_FragCoord.z); // Divide by far to store depth in range 0.0 - 1.0
}
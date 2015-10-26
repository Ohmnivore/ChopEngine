attribute vec3 position;
attribute vec3 meanPosition;
attribute vec3 normal;
attribute vec3 uv;

varying vec3 FragPos;
varying vec3 MeanFragPos;
varying vec3 Normal;
varying vec3 UV;

uniform mat4 m;
uniform mat4 v;
uniform mat4 p;

void main()
{
    vec4 worldPos = m * vec4(position, 1.0);
    FragPos = worldPos.xyz; 
    MeanFragPos = (m * vec4(meanPosition, 1.0)).xyz; 
    gl_Position = p * v * worldPos;
    
    // mat3 normalMatrix = transpose(inverse(mat3(m)));
    // Normal = normalize(normalMatrix * normal);
	Normal = normal;
	
    UV = uv;
}
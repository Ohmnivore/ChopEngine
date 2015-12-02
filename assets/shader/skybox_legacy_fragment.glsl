#version 330 core
in vec2 TexCoords;
out vec4 color;

uniform sampler2D skybox;

void main()
{    
    color = texture(skybox, TexCoords);
    //color = texture(skybox, vec2(0.537109375, 0.46223958333));
	//color = vec4(1, 1, 1, 1);
}
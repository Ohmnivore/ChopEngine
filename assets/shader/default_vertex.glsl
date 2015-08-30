#version 330 core

layout(location = 0) in vec3 positionModelSpace;
layout(location = 1) in vec3 normalModelSpace;
layout(location = 2) in vec3 meanPositionModelSpace;
layout(location = 3) in vec3 meanNormalModelSpace;

out vec3 inPositionModelSpace;
out vec3 iNormalModelSpace;
out vec3 inMeanPositionModelSpace;
out vec3 inMeanNormalModelSpace;

uniform mat4 mvp;

void main()
{
    inPositionModelSpace = positionModelSpace;
    iNormalModelSpace = normalModelSpace;
    inMeanPositionModelSpace = meanPositionModelSpace;
    inMeanNormalModelSpace = meanNormalModelSpace;
	
	gl_Position = mvp * vec4(positionModelSpace, 1);
}

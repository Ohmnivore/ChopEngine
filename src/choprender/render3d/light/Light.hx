package choprender.render3d.light;

import choprender.render3d.opengl.GLUtil;
import choprender.render3d.opengl.GL;
import glm.Vec3;
import choprender.render3d.opengl.GL.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class Light
{
	public var energy:Float;
	public var color:Vec3;
	public var distance:Float;
	public var useSpecular:Bool;
	public var useDiffuse:Bool;
	public var castShadows:Bool;
	
	public function new() 
	{
		energy = 1.0;
		color = new Vec3(1.0, 1.0, 1.0);
		distance = 500.0;
		useSpecular = true;
		useDiffuse = true;
		castShadows = true;
	}
	
	public function setUniforms(P:GLProgram, I:Int):Void
	{
		GLUtil.setUniformElementVec(P, "allLights", I, "color", color);
		GLUtil.setUniformElementBasic(P, "allLights", I, "useDiffuse", useDiffuse);
		GLUtil.setUniformElementBasic(P, "allLights", I, "useSpecular", useSpecular);
		GLUtil.setUniformElementBasic(P, "allLights", I, "distance", distance);
		GLUtil.setUniformElementBasic(P, "allLights", I, "energy", energy);
	}
}
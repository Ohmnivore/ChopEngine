package choprender.render3d.light;

import choprender.render3d.opengl.GLUtil;
import choprender.render3d.opengl.GL;
import glm.Vec3;
import choprender.render3d.opengl.GL.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class SunLight extends Light
{
	public var dir:Vec3;
	
	public function new() 
	{
		super();
		dir = new Vec3(-1.0, -1.0, 0.5);
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElementVec(P, "allLights", I, "direction", dir);
		GLUtil.setUniformElementBasic(P, "allLights", I, "type", 0);
	}
}
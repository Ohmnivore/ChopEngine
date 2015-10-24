package choprender.render3d.light;

import choprender.render3d.opengl.GLUtil;
import choprender.render3d.opengl.GL;
import chop.math.Vec3;
import chop.math.Util;
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
		dir = Vec3.fromValues(-1.0, -1.0, 0.5);
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "direction", dir);
		//GLUtil.setUniformElement(P, "allLights", I, "type", 0);
		
		GLUtil.setInt(GLUtil.getLocation(P, "allLights[" + I + "].type"), 0);
	}
}
package choprender.render3d.light;

import choprender.render3d.GLUtil;
import choprender.render3d.opengl.GL;
import hxmath.math.Vector3;
import chop.math.Util;
import choprender.render3d.opengl.GL.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class SunLight extends Light
{
	public var dir:Vector3;
	
	public function new() 
	{
		super();
		dir = new Vector3(-1.0, -1.0, 0.5);
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "direction", Util.Vector3ToGL(dir));
		//GLUtil.setUniformElement(P, "allLights", I, "type", 0);
		
		GLUtil.setInt(GLUtil.getLocation(P, "allLights[" + I + "].type"), 0);
	}
}
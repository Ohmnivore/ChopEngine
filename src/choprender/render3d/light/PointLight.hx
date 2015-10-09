package choprender.render3d.light;

import choprender.render3d.GLUtil;
import choprender.render3d.opengl.GL;
import chop.math.Vec3;
import chop.math.Util;
import choprender.render3d.opengl.GL.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class PointLight extends Light
{
	public var pos:Vec3;
	
	public function new() 
	{
		super();
		pos = Vec3.fromValues(0.0, 0.0, 0.0);
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "position", Util.Vector3ToGL(pos));
		//GLUtil.setUniformElement(P, "allLights", I, "type", 1);
		
		GLUtil.setInt(GLUtil.getLocation(P, "allLights[" + I + "].type"), 1);
	}
}
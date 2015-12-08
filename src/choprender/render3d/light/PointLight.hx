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
class PointLight extends Light
{
	public var pos:Vec3;
	
	public var constant:Float;
	public var linear:Float;
	public var quadratic:Float;
	
	public function new() 
	{
		super();
		pos = Vec3.fromValues(0.0, 0.0, 0.0);
		constant = 0.0;
		linear = 0.0;
		quadratic = 1.0;
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "position", pos);
		//GLUtil.setUniformElement(P, "allLights", I, "type", 1);
		
		GLUtil.setInt(GLUtil.getLocation(P, "allLights[" + I + "].type"), 1);
		
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].constant"), constant);
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].linear"), linear);
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].quadratic"), quadratic);
	}
}
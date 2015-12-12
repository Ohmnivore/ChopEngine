package choprender.render3d.light;

import choprender.render3d.opengl.GLUtil;
import choprender.render3d.opengl.GL;
import glm.Vec3;
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
		pos = new Vec3(0.0, 0.0, 0.0);
		constant = 0.0;
		linear = 0.0;
		quadratic = 1.0;
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElementVec(P, "allLights", I, "position", pos);
		GLUtil.setUniformElementBasic(P, "allLights", I, "type", 1);
		GLUtil.setUniformElementBasic(P, "allLights", I, "constant", constant);
		GLUtil.setUniformElementBasic(P, "allLights", I, "linear", linear);
		GLUtil.setUniformElementBasic(P, "allLights", I, "quadratic", quadratic);
	}
}
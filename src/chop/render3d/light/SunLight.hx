package chop.render3d.light;

import chop.render3d.GLUtil;
import hxmath.math.Vector3;
import chop.math.Util;
import chop.render3d.opengl.GL.GLProgram;

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
		GLUtil.setUniformElement(P, "allLights", I, "type", 0);
	}
}
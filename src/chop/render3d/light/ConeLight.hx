package chop.render3d.light;
import chop.render3d.GLUtil;
import hxmath.math.Vector3;
import chop.math.Util;
//import snow.modules.opengl.GL.GLProgram;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class ConeLight extends Light
{
	public var pos:Vector3;
	public var dir:Vector3;
	public var coneAngle:Float;
	
	public function new() 
	{
		super();
		pos = new Vector3(0.0, 0.0, 0.0);
		dir = new Vector3( -1.0, -1.0, 0.5);
		coneAngle = 20.0;
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "direction", Util.Vector3ToGL(dir));
		GLUtil.setUniformElement(P, "allLights", I, "position", Util.Vector3ToGL(pos));
		GLUtil.setUniformElement(P, "allLights", I, "coneAngle", coneAngle);
		GLUtil.setUniformElement(P, "allLights", I, "type", 2);
	}
}
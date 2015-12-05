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
class ConeLight extends Light
{
	public var pos:Vec3;
	public var dir:Vec3;
	public var coneAngle:Float;
	public var interiorConeAngle:Float;
	
	public function new() 
	{
		super();
		pos = Vec3.fromValues(0.0, 0.0, 0.0);
		dir = Vec3.fromValues( -1.0, -1.0, 0.5);
		coneAngle = 20.0;
		interiorConeAngle = 15.0;
	}
	
	override public function setUniforms(P:GLProgram, I:Int):Void 
	{
		super.setUniforms(P, I);
		GLUtil.setUniformElement(P, "allLights", I, "direction", dir);
		GLUtil.setUniformElement(P, "allLights", I, "position", pos);
		//GLUtil.setUniformElement(P, "allLights", I, "coneAngle", coneAngle);
		//GLUtil.setUniformElement(P, "allLights", I, "type", 2);
		
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].coneAngle"), coneAngle);
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].interiorConeAngle"), interiorConeAngle);
		GLUtil.setInt(GLUtil.getLocation(P, "allLights[" + I + "].type"), 2);
	}
}
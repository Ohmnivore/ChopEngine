package choprender.render3d.light;

import choprender.render3d.opengl.GL.GLProgram;
import choprender.render3d.opengl.GLUtil;
import glm.Vec3;

/**
 * ...
 * @author Ohmnivore
 */
class LightState
{
	public var horizonColor:Vec3;
	public var zenithColor:Vec3;
	public var ambientColor:Vec3;
	public var ambientIntensity:Float;
	public var gamma:Float;
	public var lights:Array<Light>;
	
	public function new() 
	{
		horizonColor = new Vec3(0.0, 0.0, 0.0);
		zenithColor = new Vec3(0.0, 0.0, 0.0);
		ambientColor = new Vec3(0.05, 0.05, 0.05);
		ambientIntensity = 0.1;
		gamma = 1.0 / 2.2;
		lights = [];
	}
	
	public function setUniforms(P:GLProgram):Void
	{
		GLUtil.setUniformVec(P, "ambientColor", ambientColor);
		GLUtil.setUniformBasic(P, "ambientIntensity", ambientIntensity);
		GLUtil.setUniformBasic(P, "gamma", gamma);
	}
}
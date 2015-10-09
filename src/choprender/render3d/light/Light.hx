package choprender.render3d.light;

import choprender.render3d.GLUtil;
import choprender.render3d.opengl.GL;
import chop.math.Vec3;
import choprender.render3d.opengl.GL.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class Light
{
	public var energy:Float;
	public var color:Vec3;
	public var distance:Float;
	public var useSpecular:Bool;
	public var useDiffuse:Bool;
	public var castShadows:Bool;
	
	public function new() 
	{
		energy = 1.0;
		color = Vec3.fromValues(1.0, 1.0, 1.0);
		distance = 500.0;
		useSpecular = true;
		useDiffuse = true;
		castShadows = true;
	}
	
	public function setUniforms(P:GLProgram, I:Int):Void
	{
		//GLUtil.setUniformElement(P, "allLights", I, "castShadows", light.castShadows);
		GLUtil.setUniformElement(P, "allLights", I, "color", color);
		//GLUtil.setUniformElement(P, "allLights", I, "distance", distance);
		//GLUtil.setUniformElement(P, "allLights", I, "energy", energy);
		GLUtil.setUniformElement(P, "allLights", I, "useDiffuse", useDiffuse);
		GLUtil.setUniformElement(P, "allLights", I, "useSpecular", useSpecular);
		
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].distance"), distance);
		GLUtil.setFloat(GLUtil.getLocation(P, "allLights[" + I + "].energy"), energy);
	}
}
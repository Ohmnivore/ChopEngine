package choprender.render3d.light;

import chop.math.Vec3;

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
		horizonColor = Vec3.fromValues(0.0, 0.0, 0.0);
		zenithColor = Vec3.fromValues(0.0, 0.0, 0.0);
		ambientColor = Vec3.fromValues(0.05, 0.05, 0.05);
		ambientIntensity = 0.1;
		gamma = 1.0 / 2.2;
		lights = [];
	}
}
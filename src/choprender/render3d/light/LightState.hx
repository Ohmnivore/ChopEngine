package choprender.render3d.light;

import hxmath.math.Vector3;

/**
 * ...
 * @author Ohmnivore
 */
class LightState
{
	public var horizonColor:Vector3;
	public var zenithColor:Vector3;
	public var ambientColor:Vector3;
	public var ambientIntensity:Float;
	public var gamma:Float;
	public var lights:Array<Light>;
	
	public function new() 
	{
		horizonColor = new Vector3(0.0, 0.0, 0.0);
		zenithColor = new Vector3(0.0, 0.0, 0.0);
		ambientColor = new Vector3(0.05, 0.05, 0.05);
		ambientIntensity = 0.1;
		gamma = 1.0 / 2.2;
		lights = [];
	}
}
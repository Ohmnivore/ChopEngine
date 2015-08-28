package chop.gen;

import chop.render3d.Camera;
import hxmath.math.Vector3;

/**
 * ...
 * @author Ohmnivore
 */
class Object extends Basic
{
	public var cam:Camera;
	public var cams:Array<Camera>;
	public var health:Float;
	
	public var pos:Vector3;
	public var rot:Vector3;
	public var scale:Vector3;
	
	public function new() 
	{
		super();
		
		cam = Global.cam;
		cams = Global.cams.slice(0, Global.cams.length);
		health = 1.0;
		
		pos = new Vector3(0, 0, 0);
		rot = new Vector3(0, 0, 0);
		scale = new Vector3(1, 1, 1);
	}
}
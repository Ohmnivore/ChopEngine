package chop.gen;

import chop.gen.Basic;
import choprender.GlobalRender;
import choprender.render3d.Camera;
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
		
		cam = GlobalRender.cam;
		cams = GlobalRender.cams.slice(0, GlobalRender.cams.length);
		health = 1.0;
		
		pos = new Vector3(0, 0, 0);
		rot = new Vector3(0, 0, 0);
		scale = new Vector3(1, 1, 1);
	}
	
	static public function copy(D:Object, S:Object):Void 
	{
		Basic.copy(D, S);
		
		D.cam = S.cam;
		D.cams.splice(0, D.cams.length);
		for (c in S.cams)
			D.cams.push(c);
		D.health = S.health;
		
		D.pos.copyFromShape(S.pos);
		D.rot.copyFromShape(S.rot);
		D.scale.copyFromShape(S.scale);
	}
}
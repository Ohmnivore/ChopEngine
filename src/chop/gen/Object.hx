package chop.gen;

import chop.gen.Basic;
import choprender.GlobalRender;
import choprender.render3d.Camera;
import chop.math.Vec3;

/**
 * ...
 * @author Ohmnivore
 */
class Object extends Basic
{
	public var cam:Camera;
	public var cams:Array<Camera>;
	public var health:Float;
	
	public var pos:Vec3;
	public var rot:Vec3;
	public var scale:Vec3;
	
	public function new() 
	{
		super();
		
		cam = GlobalRender.cam;
		cams = GlobalRender.cams.slice(0, GlobalRender.cams.length);
		health = 1.0;
		
		pos = Vec3.fromValues(0, 0, 0);
		rot = Vec3.fromValues(0, 0, 0);
		scale = Vec3.fromValues(1, 1, 1);
	}
	
	static public function copy(D:Object, S:Object):Void 
	{
		Basic.copy(D, S);
		
		D.cam = S.cam;
		D.cams.splice(0, D.cams.length);
		for (c in S.cams)
			D.cams.push(c);
		D.health = S.health;
		
		D.pos.copy(S.pos);
		D.rot.copy(S.rot);
		D.scale.copy(S.scale);
	}
}
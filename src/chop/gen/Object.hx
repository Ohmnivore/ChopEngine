package chop.gen;

import chop.gen.Basic;
import glm.Vec3;

/**
 * ...
 * @author Ohmnivore
 */
class Object extends Basic
{
	public var health:Float;
	
	public var pos:Vec3;
	public var rot:Vec3;
	public var scale:Vec3;
	
	public function new() 
	{
		super();
		
		health = 1.0;
		
		pos = new Vec3(0, 0, 0);
		rot = new Vec3(0, 0, 0);
		scale = new Vec3(1, 1, 1);
	}
	
	static public function copy(D:Object, S:Object):Void 
	{
		Basic.copy(D, S);
		
		D.health = S.health;
		
		D.pos.copy(S.pos);
		D.rot.copy(S.rot);
		D.scale.copy(S.scale);
	}
}
package chop.gen;

import chop.group.Group;
import chop.phys.PhysState;
import chop.render3d.light.LightState;

/**
 * ...
 * @author Ohmnivore
 */
class State extends Group
{
	public var lights:LightState;
	public var phys:PhysState;
	
	public function new() 
	{
		super();
	}
	
	public function create():Void
	{
		lights = new LightState();
		phys = new PhysState();
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		phys.step(Elapsed);
	}
}
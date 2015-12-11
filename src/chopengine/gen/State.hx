package chopengine.gen;

import chop.group.Group;
import chopengine.phys.PhysState;
import choprender.render3d.light.LightState;
import mint.focus.Focus;

import chop.math.Vec4;
import mint.layout.margins.Margins;

/**
 * ...
 * @author Ohmnivore
 */
class State extends Group
{
	public var lights:LightState;
	public var phys:PhysState;
	public var canvas:mint.Canvas;
	public var layout:Margins;
	public var focus:Focus;
	
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
		canvas.update(Elapsed);
	}
}
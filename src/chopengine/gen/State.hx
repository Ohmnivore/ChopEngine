package chopengine.gen;

import chop.group.Group;
import choprender.render3d.light.LightState;

import chop.math.Vec4;
import mint.layout.margins.Margins;

/**
 * ...
 * @author Ohmnivore
 */
class State extends Group
{
	public var lights:LightState;
	public var canvas:mint.Canvas;
	public var layout:Margins;
	
	public function new() 
	{
		super();
	}
	
	public function create():Void
	{
		lights = new LightState();
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		canvas.update(Elapsed);
	}
}
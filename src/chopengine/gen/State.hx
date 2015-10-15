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
		layout = new Margins();
		canvas = new mint.Canvas({
			name:'canvas',
			rendering: Main.rendering,
			options: {
				group: this
			},
			x: 0, y:0, w: SnowApp._snow.window.width, h: SnowApp._snow.window.height
		});
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		canvas.update(Elapsed);
	}
}
package chopengine.input;

import snow.types.Types;

/**
 * ...
 * @author Ohmnivore
 */
class Mouse
{
	public var x:Int = 0;
	public var y:Int = 0;
	public var xRel:Int = 0;
	public var yRel:Int = 0;
	public var leftPressed:Bool = false;
	public var middlePressed:Bool = false;
	public var rightPressed:Bool = false;
	
	public function new() 
	{
		
	}
	
	public function update():Void
	{
		xRel = 0;
		yRel = 0;
	}
	
	public function onmousemove(X:Int, Y:Int, XRel:Int, YRel:Int):Void
	{
		x = X;
		y = Y;
		xRel = XRel;
		yRel = YRel;
	}
	
	public function onmousedown(button:Int) 
	{
		if (button == 1)
			leftPressed = true;
		else if (button == 2)
			middlePressed = true;
		else if (button == 3)
			rightPressed = true;
	}
	
	public function onmouseup(button:Int) 
	{
		if (button == 1)
			leftPressed = false;
		else if (button == 2)
			middlePressed = false;
		else if (button == 3)
			rightPressed = false;
	}
}
package choprender.mint;

import haxe.macro.Context;
import haxe.macro.Expr;

import mint.types.Types.MouseButton;
import mint.types.Types.MouseEvent;
import mint.types.Types.InteractState;

/**
 * ...
 * @author Ohmnivore
 */
class Convert
{
	static public function coord(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return C / SnowApp._snow.window.width;
		else
			return C / SnowApp._snow.window.height;
	}
	static public function coordY(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return -C / SnowApp._snow.window.width;
		else
			return -C / SnowApp._snow.window.height;
	}
	static public function coordZ(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return -C / SnowApp._snow.window.width * 10.0;
		else
			return -C / SnowApp._snow.window.height * 10.0;
	}
	
	static public function def(V:Dynamic, Def:Dynamic):Dynamic
	{
		if (V == null)
			V = Def;
		return V;
	}
	
	static private function button(Button:Int):MouseButton
	{
		if (Button == 1)
			return MouseButton.left;
		else if (Button == 2)
			return MouseButton.middle;
		else if (Button == 3)
			return MouseButton.right;
		else
			return 0;
	}
	static public function mouseEvent(X:Int, Y:Int, RelX:Int, RelY:Int, Button:Int, Timestamp:Float, State:InteractState):MouseEvent
	{
		return {
            state       : State,
            button      : button(Button),
            timestamp   : Timestamp,
            x           : X,
            y           : Y,
            xrel        : RelX,
            yrel        : RelY,
            bubble      : true
        };
	}
}
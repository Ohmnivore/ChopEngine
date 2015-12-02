package choprender.mint;
import chop.math.Vec4;
import mint.Control;

/**
 * ...
 * @author Ohmnivore
 */
class Convert
{
	static public function bounds(C:Control):Vec4
	{
		if (C == null)
			return null;
		return Vec4.fromValues(C.x, C.y, C.w, C.h);
	}
	static public function coord(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return (C / SnowApp._snow.window.width) * 2.0;
		else
			return (C / SnowApp._snow.window.height) * 2.0;
	}
	static public function coordX(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return ((C - SnowApp._snow.window.width / 2.0) / SnowApp._snow.window.width) * 2.0;
		else
			return ((C - SnowApp._snow.window.width / 2.0) / SnowApp._snow.window.height) * 2.0;
	}
	static public function coordY(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return ((-C + SnowApp._snow.window.height / 2.0) / SnowApp._snow.window.width) * 2.0;
		else
			return ((-C + SnowApp._snow.window.height / 2.0) / SnowApp._snow.window.height) * 2.0;
	}
	static public function coordZ(C:Float):Float 
	{
		if (SnowApp._snow.window.width > SnowApp._snow.window.height)
			return C / SnowApp._snow.window.width / 10.0;
		else
			return C / SnowApp._snow.window.height / 10.0;
	}
	
	static public function def(V:Dynamic, Def:Dynamic):Dynamic
	{
		if (V == null)
			V = Def;
		return V;
	}
	
	static private function button(B:Int):mint.types.Types.MouseButton
	{
		if (B == 1)
			return mint.types.Types.MouseButton.left;
		else if (B == 2)
			return mint.types.Types.MouseButton.middle;
		else if (B == 3)
			return mint.types.Types.MouseButton.right;
		else
			return mint.types.Types.MouseButton.none;
	}
	static public function mouseEvent(X:Int, Y:Int, RelX:Int, RelY:Int, B:Int, Timestamp:Float, State:mint.types.Types.InteractState):mint.types.Types.MouseEvent
	{
		return {
            state       : State,
            button      : button(B),
            timestamp   : Timestamp,
            x           : X,
            y           : Y,
            xrel        : RelX,
            yrel        : RelY,
            bubble      : true
        };
	}
	
	static private function textEventType(T:snow.types.Types.TextEventType):mint.types.Types.TextEventType
	{
		if (T == snow.types.Types.TextEventType.edit)
			return mint.types.Types.TextEventType.edit;
		else if (T == snow.types.Types.TextEventType.input)
			return mint.types.Types.TextEventType.input;
		else
			return mint.types.Types.TextEventType.unknown;
    }
	static public function textEvent(Text:String, Start:Int, Length:Int, T:snow.types.Types.TextEventType, Timestamp:Float):mint.types.Types.TextEvent
	{
		return {
            text      : Text,
            type      : textEventType(T),
            timestamp : Timestamp,
            start     : Start,
            length    : Length,
            bubble    : true
        };
	}
	
	static private function keyCode(K:Int):mint.types.Types.KeyCode
	{
		if (K == snow.types.Types.Key.left) return mint.types.Types.KeyCode.left;
		else if (K == snow.types.Types.Key.right) return mint.types.Types.KeyCode.right;
		else if (K == snow.types.Types.Key.up) return mint.types.Types.KeyCode.up;
		else if (K == snow.types.Types.Key.down) return mint.types.Types.KeyCode.down;
		else if (K == snow.types.Types.Key.backspace) return mint.types.Types.KeyCode.backspace;
		else if (K == snow.types.Types.Key.delete) return mint.types.Types.KeyCode.delete;
		else if (K == snow.types.Types.Key.tab) return mint.types.Types.KeyCode.tab;
		else if (K == snow.types.Types.Key.enter) return mint.types.Types.KeyCode.enter;
		else return mint.types.Types.KeyCode.unknown;
    }
	static private function modState(M:snow.types.Types.ModState):mint.types.Types.ModState
	{
        return
		{
            none:   M.none,
            lshift: M.lshift,
            rshift: M.rshift,
            lctrl:  M.lctrl,
            rctrl:  M.rctrl,
            lalt:   M.lalt,
            ralt:   M.ralt,
            lmeta:  M.lmeta,
            rmeta:  M.rmeta,
            num:    M.num,
            caps:   M.caps,
            mode:   M.mode,
            ctrl:   M.ctrl,
            shift:  M.shift,
            alt:    M.alt,
            meta:   M.meta,
        };
    }
	static public function keyEvent(Keycode:Int, Mod:snow.types.Types.ModState, Timestamp:Float, State:mint.types.Types.InteractState):mint.types.Types.KeyEvent
	{
		return {
            state       : State,
            keycode     : Keycode,
            timestamp   : Timestamp,
            key         : keyCode(Keycode),
            mod         : modState(Mod),
            bubble      : true
        };
	}
}
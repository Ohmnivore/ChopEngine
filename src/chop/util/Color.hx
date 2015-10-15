package chop.util;
import chop.math.Vec4;

/**
 * ...
 * @author Ohmnivore
 */

abstract Color(Array<Float>)
{
	public function new()
	{
		this = new Array<Float>();
		this[0] = 0;
		this[1] = 0;
		this[2] = 0;
	}
	
	public var r(get, set):Float;
	public function get_r():Float
	{
		return this[0];
	}
	public function set_r(V:Float):Float
	{
		this[0] = V;
		return V;
	}
	
	public var g(get, set):Float;
	public function get_g():Float
	{
		return this[1];
	}
	public function set_g(V:Float):Float
	{
		this[1] = V;
		return V;
	}
	
	public var b(get, set):Float;
	public function get_b():Float
	{
		return this[2];
	}
	public function set_b(V:Float):Float
	{
		this[2] = V;
		return V;
	}
	
	public static function fromValues(r:Float, g:Float, b:Float):Color
	{
		var v = new Color();
		v.set(r, g, b);
		return v;
	}

	public static function clone(v:Color):Color
	{
		return v.cp();
	}
	
	public function copy(v:Color):Color
	{
		this[0] = v.r;
		this[1] = v.g;
		this[2] = v.b;
		return cast this;
	}

	public function cp():Color
	{
		var v = new Array<Float>();
		v[0] = this[0];
		v[1] = this[1];
		v[2] = this[2];
		return cast v;
	}

	public function set(r:Float, g:Float, b:Float):Color
	{
		this[0] = r;
		this[1] = g;
		this[2] = b;
		return cast this;
	}
	
	public function rgb(RGB:Int):Color
	{
		var _r = RGB >> 16;
        var _g = RGB >> 8 & 0xFF;
        var _b = RGB & 0xFF;
        r = _r / 255;
        g = _g / 255;
        b = _b / 255;
        return cast this;
	}
	static public function fromRGB(RGB:Int):Color
	{
		var c:Color = new Color();
		return c.rgb(RGB);
	}
}
package chop.util;
import chop.math.Vec4;

/**
 * ...
 * @author Ohmnivore
 */

class Color extends Vec4
{
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
	
	public var a(get, set):Float;
	public function get_a():Float
	{
		return this[3];
	}
	public function set_a(V:Float):Float
	{
		this[3] = V;
		return V;
	}
	
	public function rgba(RGB:Int, A:Float = 1.0):Color
	{
		var _r = _i >> 16;
        var _g = _i >> 8 & 0xFF;
        var _b = _i & 0xFF;
        r = _r / 255;
        g = _g / 255;
        b = _b / 255;
		a = A;
        return this;
    }
	static public function fromRGBA(RGB:Int, A:Float = 1.0):Color
	{
		var c:Color = new Color();
		return c.rgba(RGB, A);
	}
}
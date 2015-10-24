package chop.math;

import chop.math.Quat;
import chop.math.Vec3;
import chop.math.Mat4;
import chop.math.Vec4;

/**
 * ...
 * @author Ohmnivore
 */
class Util
{
	static public function degToRad(Deg:Float):Float
	{
		return Math.PI / 180 * Deg;
	}
	static public function radToDeg(Rad:Float):Float
	{
		return 180 / Math.PI * Rad;
	}
	
	static public function eulerDegToMatrix4x4(X:Float, Y:Float, Z:Float):Mat4
	{
		return eulerRadToMatrix4x4(degToRad(X), degToRad(Y), degToRad(Z));
	}
	static public function eulerRadToMatrix4x4(X:Float, Y:Float, Z:Float):Mat4
	{
		return new Mat4().fromQuat(Quat.fromEuler(X, Y, Z));
	}
}
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
	
	static public function Vector3ToGLSoft(V:Vec3):Vec3
	{
		return Vec3.fromValues(V.x, V.z, V.y);
	}
	
	static public function Vector3ToGL(V:Vec3):Vec3
	{
		return Vec3.fromValues(V.x, V.z, -V.y);
	}
	
	static public function perspective(FOV:Float, Ratio:Float, DisplayMin:Float, DisplayMax:Float):Mat4
	{
		return new Mat4().perspective(FOV, Ratio, DisplayMin, DisplayMax);
	}
	
	static public function lookAt(Eye:Vec3, Center:Vec3, Up:Vec3):Mat4
	{
		return new Mat4().lookAt(Eye, Center, Up);
	}
	
	static public function translate(M:Mat4, V:Vec3):Mat4
	{
		return M.trans(V);
	}
	
	static public function scale(M:Mat4, V:Vec3):Mat4
	{
		return M.scale(V);
	}
	
	static public function eulerToMatrix4x4(X:Float, Y:Float, Z:Float):Mat4
	{
		return new Mat4().fromQuat(Quat.fromEuler(X, Y, Z));
	}
	
	static public function matrix4MultVec4(M:Mat4, V:Vec4):Vec4
	{
		return V.transMat4(M);
	}
	
	static public function invertMatrix4x4(Mat:Mat4):Mat4
	{
		return Mat.invert();
	}
}
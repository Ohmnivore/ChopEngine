package chop.math;

import hxmath.math.Vector3;
import hxmath.math.Matrix4x4;

/**
 * ...
 * @author Ohmnivore
 */
class Util
{
	static public function Vector3ToGLSoft(V:Vector3):Vector3
	{
		return new Vector3(V.x, V.z, V.y);
	}
	
	static public function Vector3ToGL(V:Vector3):Vector3
	{
		return new Vector3(V.x, V.z, -V.y);
	}
	
	static public function perspective(FOV:Float, Ratio:Float, DisplayMin:Float, DisplayMax:Float):Matrix4x4
	{
		var tanHalfFovy:Float = Math.tan(FOV / 2.0);
		
		var result:Matrix4x4 = Matrix4x4.zero;
		result.setElement(0, 0, 1.0 / (Ratio * tanHalfFovy));
		result.setElement(1, 1, 1.0 / (tanHalfFovy));
		result.setElement(2, 2, - (DisplayMax + DisplayMin) / (DisplayMax - DisplayMin));
		result.setElement(3, 2, -1.0);
		result.setElement(2, 3, -(2.0 * DisplayMax * DisplayMin) / (DisplayMax - DisplayMin));
		return result;
	}
	
	static public function lookAt(Eye:Vector3, Center:Vector3, Up:Vector3):Matrix4x4
	{
		var f:Vector3 = (Center - Eye).normalize();
		var s:Vector3 = (f % Up).normalize();
		var u:Vector3 = s % f;
		
		var result:Matrix4x4 = Matrix4x4.identity;
		result.setElement(0, 0, s.x);
		result.setElement(0, 1, s.y);
		result.setElement(0, 2, s.z);
		result.setElement(1, 0, u.x);
		result.setElement(1, 1, u.y);
		result.setElement(1, 2, u.z);
		result.setElement(2, 0, -f.x);
		result.setElement(2, 1, -f.y);
		result.setElement(2, 2, -f.z);
		result.setElement(0, 3, -(s * Eye));
		result.setElement(1, 3, -(u * Eye));
		result.setElement(2, 3, f * Eye);
		return result;
	}
	
	static public function translate(M:Matrix4x4, V:Vector3):Matrix4x4
	{
		var transformationMatrix:Matrix4x4 = new Matrix4x4(
			1.0, 0.0, 0.0, 0.0,
			0.0, 1.0, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			V.x, V.y, V.z, 1.0
		);
		return M * transformationMatrix;
	}
	
	static public function scale(M:Matrix4x4, V:Vector3):Matrix4x4
	{
		var res:Matrix4x4 = Matrix4x4.zero;
		res.setElement(0, 0, M.getElement(0, 0) * V.x);
		res.setElement(0, 1, M.getElement(0, 1) * V.x);
		res.setElement(0, 2, M.getElement(0, 2) * V.x);
		res.setElement(0, 3, M.getElement(0, 3) * V.x);
		res.setElement(1, 0, M.getElement(1, 0) * V.y);
		res.setElement(1, 1, M.getElement(1, 1) * V.y);
		res.setElement(1, 2, M.getElement(1, 2) * V.y);
		res.setElement(1, 3, M.getElement(1, 3) * V.y);
		res.setElement(2, 0, M.getElement(2, 0) * V.z);
		res.setElement(2, 1, M.getElement(2, 1) * V.z);
		res.setElement(2, 2, M.getElement(2, 2) * V.z);
		res.setElement(2, 3, M.getElement(2, 3) * V.z);
		res.setElement(3, 0, M.getElement(3, 0));
		res.setElement(3, 1, M.getElement(3, 1));
		res.setElement(3, 2, M.getElement(3, 2));
		res.setElement(3, 3, M.getElement(3, 3));
		return res;
	}
	
	static public function eulerToMatrix4x4(X:Float, Y:Float, Z:Float):Matrix4x4
	{
		var ch:Float = Math.cos(Y);
		var sh:Float = Math.sin(Y);
		var ca:Float = Math.cos(Z);
		var sa:Float = Math.sin(Z);
		var cb:Float = Math.cos(X);
		var sb:Float = Math.sin(X);
		
		var res:Matrix4x4 = Matrix4x4.identity;
		res.m00 = ch * ca;
		res.m01 = sh*sb - ch*sa*cb;
		res.m02 = ch*sa*sb + sh*cb;
		res.m10 = sa;
		res.m11 = ca*cb;
		res.m12 = -ca*sb;
		res.m20 = -sh*ca;
		res.m21 = sh*sa*cb + ch*sb;
		res.m22 = -sh * sa * sb + ch * cb;
		return res;
	}
}
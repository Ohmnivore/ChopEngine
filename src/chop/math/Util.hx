package chop.math;

import com.rsredsq.math.Quat;
import com.rsredsq.math.Vec3;
import com.rsredsq.math.Mat4;
import com.rsredsq.math.Vec4;

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
		//return Vec3.fromValues(V.x, V.y, V.z);
	}
	
	static public function Vector3ToGL(V:Vec3):Vec3
	{
		return Vec3.fromValues(V.x, V.z, -V.y);
		//return Vec3.fromValues(V.x, V.z, V.y);
		//return Vec3.fromValues(V.x, V.y, V.z);
	}
	
	static public function perspective(FOV:Float, Ratio:Float, DisplayMin:Float, DisplayMax:Float):Mat4
	{
		var tanHalfFovy:Float = Math.tan(FOV / 2.0);
		
		var result:Mat4 = Mat4.newZero();
		//result.setElement(0, 0, 1.0 / (Ratio * tanHalfFovy));
		//result.setElement(1, 1, 1.0 / (tanHalfFovy));
		//result.setElement(2, 2, - (DisplayMax + DisplayMin) / (DisplayMax - DisplayMin));
		//result.setElement(3, 2, -1.0);
		//result.setElement(2, 3, -(2.0 * DisplayMax * DisplayMin) / (DisplayMax - DisplayMin));
		//result.arrayWrite(0, 1.0 / (Ratio * tanHalfFovy));
		//result.arrayWrite(5, 1.0 / (tanHalfFovy));
		//result.arrayWrite(10, - (DisplayMax + DisplayMin) / (DisplayMax - DisplayMin));
		//result.arrayWrite(11, -1.0);
		//result.arrayWrite(14, -(2.0 * DisplayMax * DisplayMin) / (DisplayMax - DisplayMin));
		//return result;
		
		return new Mat4().perspective(FOV, Ratio, DisplayMin, DisplayMax);
	}
	
	static public function lookAt(Eye:Vec3, Center:Vec3, Up:Vec3):Mat4
	{
		var f:Vec3 = (Center - Eye).norm();
		var s:Vec3 = (f.cross(Up)).norm();
		var u:Vec3 = s.cross(f);
		
		var result:Mat4 = Mat4.newIdent();
		//result.setElement(0, 0, s.x);
		//result.setElement(0, 1, s.y);
		//result.setElement(0, 2, s.z);
		//result.setElement(1, 0, u.x);
		//result.setElement(1, 1, u.y);
		//result.setElement(1, 2, u.z);
		//result.setElement(2, 0, -f.x);
		//result.setElement(2, 1, -f.y);
		//result.setElement(2, 2, -f.z);
		//result.setElement(0, 3, -(s * Eye));
		//result.setElement(1, 3, -(u * Eye));
		//result.setElement(2, 3, f * Eye);
		//result.arrayWrite(0, s.x);
		//result.arrayWrite(4, s.y);
		//result.arrayWrite(8, s.z);
		//result.arrayWrite(1, u.x);
		//result.arrayWrite(5, u.y);
		//result.arrayWrite(9, u.z);
		//result.arrayWrite(2, -f.x);
		//result.arrayWrite(6, -f.y);
		//result.arrayWrite(10, -f.z);
		//result.arrayWrite(12, -(s.dot(Eye)));
		//result.arrayWrite(13, -(u.dot(Eye)));
		//result.arrayWrite(14, f.dot(Eye));
		//return result;
		return new Mat4().lookAt(Eye, Center, Up);
	}
	
	static public function translate(M:Mat4, V:Vec3):Mat4
	{
		//var transformationMatrix:Mat4 = new Mat4(
			//1.0, 0.0, 0.0, 0.0,
			//0.0, 1.0, 0.0, 0.0,
			//0.0, 0.0, 1.0, 0.0,
			//V.x, V.y, V.z, 1.0
		//);
		//var transformationMatrix:Mat4 = Mat4.newIdent();
		//transformationMatrix.arrayWrite(12, V.x);
		//transformationMatrix.arrayWrite(13, V.y);
		//transformationMatrix.arrayWrite(14, V.z);
		//return M * transformationMatrix;
		return M.trans(V);
	}
	
	static public function scale(M:Mat4, V:Vec3):Mat4
	{
		var res:Mat4 = Mat4.newZero();
		//res.setElement(0, 0, M.getElement(0, 0) * V.x);
		//res.setElement(0, 1, M.getElement(0, 1) * V.x);
		//res.setElement(0, 2, M.getElement(0, 2) * V.x);
		//res.setElement(0, 3, M.getElement(0, 3) * V.x);
		//res.setElement(1, 0, M.getElement(1, 0) * V.y);
		//res.setElement(1, 1, M.getElement(1, 1) * V.y);
		//res.setElement(1, 2, M.getElement(1, 2) * V.y);
		//res.setElement(1, 3, M.getElement(1, 3) * V.y);
		//res.setElement(2, 0, M.getElement(2, 0) * V.z);
		//res.setElement(2, 1, M.getElement(2, 1) * V.z);
		//res.setElement(2, 2, M.getElement(2, 2) * V.z);
		//res.setElement(2, 3, M.getElement(2, 3) * V.z);
		//res.setElement(3, 0, M.getElement(3, 0));
		//res.setElement(3, 1, M.getElement(3, 1));
		//res.setElement(3, 2, M.getElement(3, 2));
		//res.setElement(3, 3, M.getElement(3, 3));
		//res.arrayWrite(0, M.arrayRead(0) * V.x);
		//res.arrayWrite(4, M.arrayRead(4) * V.x);
		//res.arrayWrite(8, M.arrayRead(8) * V.x);
		//res.arrayWrite(12, M.arrayRead(12) * V.x);
		//res.arrayWrite(1, M.arrayRead(1) * V.y);
		//res.arrayWrite(5, M.arrayRead(5) * V.y);
		//res.arrayWrite(9, M.arrayRead(9) * V.y);
		//res.arrayWrite(13, M.arrayRead(13) * V.y);
		//res.arrayWrite(2, M.arrayRead(2) * V.z);
		//res.arrayWrite(6, M.arrayRead(6) * V.z);
		//res.arrayWrite(10, M.arrayRead(10) * V.z);
		//res.arrayWrite(14, M.arrayRead(14) * V.z);
		//res.arrayWrite(3, M.arrayRead(3));
		//res.arrayWrite(7, M.arrayRead(7));
		//res.arrayWrite(11, M.arrayRead(11));
		//res.arrayWrite(15, M.arrayRead(15));
		//return res;
		return M.scale(V);
	}
	
	static public function eulerToMatrix4x4(X:Float, Y:Float, Z:Float):Mat4
	{
		var ch:Float = Math.cos(Y);
		var sh:Float = Math.sin(Y);
		var ca:Float = Math.cos(Z);
		var sa:Float = Math.sin(Z);
		var cb:Float = Math.cos(X);
		var sb:Float = Math.sin(X);
		
		var res:Mat4 = Mat4.newIdent();
		//res.m00 = ch * ca;
		//res.m01 = sh*sb - ch*sa*cb;
		//res.m02 = ch*sa*sb + sh*cb;
		//res.m10 = sa;
		//res.m11 = ca*cb;
		//res.m12 = -ca*sb;
		//res.m20 = -sh*ca;
		//res.m21 = sh*sa*cb + ch*sb;
		//res.m22 = -sh * sa * sb + ch * cb;
		res.arrayWrite(0, ch * ca);
		res.arrayWrite(4, sh*sb - ch*sa*cb);
		res.arrayWrite(8, ch*sa*sb + sh*cb);
		res.arrayWrite(1, sa);
		res.arrayWrite(5, ca*cb);
		res.arrayWrite(9, -ca*sb);
		res.arrayWrite(2, -sh*ca);
		res.arrayWrite(6, sh*sa*cb + ch*sb);
		res.arrayWrite(10, -sh * sa * sb + ch * cb);
		//return res;
		return new Mat4().fromQuat(Quat.fromEuler(X, Y, Z));
	}
	
	static public function matrix4MultVec4(M:Mat4, V:Vec4):Vec4
	{
		var res:Vec4 = Vec4.fromValues(0, 0, 0, 0);
		
		//res.x = M.m00 * V.x + M.m01 * V.y + M.m02 * V.z + M.m03 * V.w;
		//res.y = M.m10 * V.x + M.m11 * V.y + M.m12 * V.z + M.m13 * V.w;
		//res.z = M.m20 * V.x + M.m21 * V.y + M.m22 * V.z + M.m23 * V.w;
		//res.w = M.m30 * V.x + M.m31 * V.y + M.m32 * V.z + M.m33 * V.w;
		//res.x = M.arrayRead(0) * V.x + M.arrayRead(4) * V.y + M.arrayRead(8) * V.z + M.arrayRead(12) * V.w;
		//res.y = M.arrayRead(1) * V.x + M.arrayRead(5) * V.y + M.arrayRead(9) * V.z + M.arrayRead(13) * V.w;
		//res.z = M.arrayRead(2) * V.x + M.arrayRead(6) * V.y + M.arrayRead(10) * V.z + M.arrayRead(14) * V.w;
		//res.w = M.arrayRead(3) * V.x + M.arrayRead(7) * V.y + M.arrayRead(11) * V.z + M.arrayRead(15) * V.w;
		//
		//return res;
		return V.transMat4(M);
	}
	
	static public function invertMatrix4x4(Mat:Mat4):Mat4
	{
		var M:Mat4 = Mat4.newZero();
		M.copy(Mat);
		
		//var a00 = M.getArrayElement(0);  var a01 = M.getArrayElement(1);  var a02 = M.getArrayElement(2);  var a03 = M.getArrayElement(3);
		//var a10 = M.getArrayElement(4);  var a11 = M.getArrayElement(5);  var a12 = M.getArrayElement(6);  var a13 = M.getArrayElement(7);
		//var a20 = M.getArrayElement(8);  var a21 = M.getArrayElement(9);  var a22 = M.getArrayElement(10); var a23 = M.getArrayElement(11);
		//var a30 = M.getArrayElement(12); var a31 = M.getArrayElement(13); var a32 = M.getArrayElement(14); var a33 = M.getArrayElement(15);
		//var a00 = M.arrayRead(0);  var a01 = M.arrayRead(1);  var a02 = M.arrayRead(2);  var a03 = M.arrayRead(3);
		//var a10 = M.arrayRead(4);  var a11 = M.arrayRead(5);  var a12 = M.arrayRead(6);  var a13 = M.arrayRead(7);
		//var a20 = M.arrayRead(8);  var a21 = M.arrayRead(9);  var a22 = M.arrayRead(10); var a23 = M.arrayRead(11);
		//var a30 = M.arrayRead(12); var a31 = M.arrayRead(13); var a32 = M.arrayRead(14); var a33 = M.arrayRead(15);
//
		//var b00 = a00 * a11 - a01 * a10;
		//var b01 = a00 * a12 - a02 * a10;
		//var b02 = a00 * a13 - a03 * a10;
		//var b03 = a01 * a12 - a02 * a11;
		//var b04 = a01 * a13 - a03 * a11;
		//var b05 = a02 * a13 - a03 * a12;
		//var b06 = a20 * a31 - a21 * a30;
		//var b07 = a20 * a32 - a22 * a30;
		//var b08 = a20 * a33 - a23 * a30;
		//var b09 = a21 * a32 - a22 * a31;
		//var b10 = a21 * a33 - a23 * a31;
		//var b11 = a22 * a33 - a23 * a32;
//
		//// Calculate the determinant
		//var det:Float = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
//
		//if (det == 0.0000) {
			//return null;
		//}
		//det = 1.0 / det;

		//M.setArrayElement(0, (a11 * b11 - a12 * b10 + a13 * b09) * det);
		//M.setArrayElement(1, (a02 * b10 - a01 * b11 - a03 * b09) * det);
		//M.setArrayElement(2, (a31 * b05 - a32 * b04 + a33 * b03) * det);
		//M.setArrayElement(3, (a22 * b04 - a21 * b05 - a23 * b03) * det);
		//M.setArrayElement(4, (a12 * b08 - a10 * b11 - a13 * b07) * det);
		//M.setArrayElement(5, (a00 * b11 - a02 * b08 + a03 * b07) * det);
		//M.setArrayElement(6, (a32 * b02 - a30 * b05 - a33 * b01) * det);
		//M.setArrayElement(7, (a20 * b05 - a22 * b02 + a23 * b01) * det);
		//M.setArrayElement(8, (a10 * b10 - a11 * b08 + a13 * b06) * det);
		//M.setArrayElement(9, (a01 * b08 - a00 * b10 - a03 * b06) * det);
		//M.setArrayElement(10, (a30 * b04 - a31 * b02 + a33 * b00) * det);
		//M.setArrayElement(11, (a21 * b02 - a20 * b04 - a23 * b00) * det);
		//M.setArrayElement(12, (a11 * b07 - a10 * b09 - a12 * b06) * det);
		//M.setArrayElement(13, (a00 * b09 - a01 * b07 + a02 * b06) * det);
		//M.setArrayElement(14, (a31 * b01 - a30 * b03 - a32 * b00) * det);
		//M.setArrayElement(15, (a20 * b03 - a21 * b01 + a22 * b00) * det);
		//M.arrayWrite(0, (a11 * b11 - a12 * b10 + a13 * b09) * det);
		//M.arrayWrite(1, (a02 * b10 - a01 * b11 - a03 * b09) * det);
		//M.arrayWrite(2, (a31 * b05 - a32 * b04 + a33 * b03) * det);
		//M.arrayWrite(3, (a22 * b04 - a21 * b05 - a23 * b03) * det);
		//M.arrayWrite(4, (a12 * b08 - a10 * b11 - a13 * b07) * det);
		//M.arrayWrite(5, (a00 * b11 - a02 * b08 + a03 * b07) * det);
		//M.arrayWrite(6, (a32 * b02 - a30 * b05 - a33 * b01) * det);
		//M.arrayWrite(7, (a20 * b05 - a22 * b02 + a23 * b01) * det);
		//M.arrayWrite(8, (a10 * b10 - a11 * b08 + a13 * b06) * det);
		//M.arrayWrite(9, (a01 * b08 - a00 * b10 - a03 * b06) * det);
		//M.arrayWrite(10, (a30 * b04 - a31 * b02 + a33 * b00) * det);
		//M.arrayWrite(11, (a21 * b02 - a20 * b04 - a23 * b00) * det);
		//M.arrayWrite(12, (a11 * b07 - a10 * b09 - a12 * b06) * det);
		//M.arrayWrite(13, (a00 * b09 - a01 * b07 + a02 * b06) * det);
		//M.arrayWrite(14, (a31 * b01 - a30 * b03 - a32 * b00) * det);
		//M.arrayWrite(15, (a20 * b03 - a21 * b01 + a22 * b00) * det);
//
		//return M;
		return M.invert();
	}
}
package choprender.render3d.opengl;

import glm.Mat4;
import glm.Vec2;
import glm.Vec3;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLProgram;
import choprender.render3d.opengl.GL.GLUniformLocation;
import choprender.render3d.opengl.GL.Float32Array;
import glm.Vec4;

/**
 * ...
 * @author Ohmnivore
 */
class GLUtil
{
	//static public function setUniformElementSimple(Program:GLProgram, Name:String, Index:Int, Value:Dynamic)
	//{
		//setUniform(Program, Name + "[" + Std.string(Index) + "]", Value);
	//}
	
	static public function setUniformElementBasic(Program:GLProgram, Name:String, Index:Int, Property:String, Value:Dynamic)
	{
		setUniformBasic(Program, Name + "[" + Std.string(Index) + "]." + Property, Value);
	}
	static public function setUniformElementVec(Program:GLProgram, Name:String, Index:Int, Property:String, Value:Dynamic)
	{
		setUniformVec(Program, Name + "[" + Std.string(Index) + "]." + Property, Value);
	}
	static public function setUniformElementMat(Program:GLProgram, Name:String, Index:Int, Property:String, Value:Dynamic)
	{
		setUniformMat(Program, Name + "[" + Std.string(Index) + "]." + Property, Value);
	}
	
	static public function setUniformBasic(Program:GLProgram, Name:String, Value:Dynamic):Void
	{
		var loc:GLUniformLocation = GL.getUniformLocation(Program, Name);
		var isOk:Bool = true;
		isOk = loc != null;
		
		if (!isOk)
		{
			trace("Uniform " + Name + " location could not be found.");
		}
		else
		{
			if (Std.is(Value, Int))
				setInt(loc, Value);
			else if (Std.is(Value, Float))
				setFloat(loc, Value);
			else if (Std.is(Value, Bool))
				setBool(loc, Value);
			else
				trace("Unknown uniform value type passed: " + Name);
		}
	}
	
	static public function setUniformVec(Program:GLProgram, Name:String, Value:Dynamic):Void
	{
		var loc:GLUniformLocation = GL.getUniformLocation(Program, Name);
		var isOk:Bool = true;
		isOk = loc != null;
		
		if (!isOk)
		{
			trace("Uniform " + Name + " location could not be found.");
		}
		else
		{
			var arr:Array<Float> = cast Value;
			if (arr.length == 2)
				setVector2(loc, Value);
			else if (arr.length == 3)
				setVector3(loc, Value);
			else if (arr.length == 4)
				setVector4(loc, Value);
			else
				trace("Unknown uniform value type passed: " + Name);
		}
	}
	
	static public function setUniformMat(Program:GLProgram, Name:String, Value:Dynamic):Void
	{
		var loc:GLUniformLocation = GL.getUniformLocation(Program, Name);
		var isOk:Bool = true;
		isOk = loc != null;
		
		if (!isOk)
		{
			trace("Uniform " + Name + " location could not be found.");
		}
		else
		{
			var arr:Array<Float> = cast Value;
			if (arr.length == 4)
				setMatrix4x4(loc, Value);
			else
				trace("Unknown uniform value type passed: " + Name);
		}
	}
	
	static public function getLocation(Program:GLProgram, Name:String):GLUniformLocation
	{
		return GL.getUniformLocation(Program, Name);
	}
	
	static private function setBool(Location:GLUniformLocation, Value:Bool)
	{
		var v:Int = 0;
		if (Value == true)
			v = 1;
		GL.uniform1i(Location, v);
	}
	
	static public function setInt(Location:GLUniformLocation, Value:Int)
	{
		GL.uniform1i(Location, Value);
	}
	
	static public function setFloat(Location:GLUniformLocation, Value:Float)
	{
		GL.uniform1f(Location, Value);
	}
	
	static private function setVector2(Location:GLUniformLocation, Value:Vec2)
	{
		GL.uniform2f(Location, Value.x, Value.y);
	}
	
	static private function setVector3(Location:GLUniformLocation, Value:Vec3)
	{
		GL.uniform3f(Location, Value.x, Value.y, Value.z);
	}
	
	static private function setVector4(Location:GLUniformLocation, Value:Vec4)
	{
		GL.uniform4f(Location, Value.x, Value.y, Value.z, Value.w);
	}
	
	static private function setMatrix4x4(Location:GLUniformLocation, Value:Mat4)
	{
		GL.uniformMatrix4fv(Location, false, matrixToFloat32Array(Value));
	}
	
	static private function matrixToFloat32Array(M:Mat4):Float32Array
	{
		return new Float32Array(M.toArrayRowMajor());
	}
}
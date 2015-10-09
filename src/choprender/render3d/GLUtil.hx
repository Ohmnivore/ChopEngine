package choprender.render3d;

import chop.math.Mat4;
import chop.math.Vec2;
import chop.math.Vec3;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLProgram;
import choprender.render3d.opengl.GL.GLUniformLocation;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class GLUtil
{
	static public function setUniformElementSimple(Program:GLProgram, Name:String, Index:Int, Value:Dynamic)
	{
		setUniform(Program, Name + "[" + Std.string(Index) + "]", Value);
	}
	
	static public function setUniformElement(Program:GLProgram, Name:String, Index:Int, Property:String, Value:Dynamic)
	{
		setUniform(Program, Name + "[" + Std.string(Index) + "]." + Property, Value);
	}
	
	static public function setUniform(Program:GLProgram, Name:String, Value:Dynamic)
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
			if (Std.is(Value, Bool))
				setBool(loc, Value);
			else if (Std.is(Value, Array))
			{
				var arr:Array<Float> = cast Value;
				if (arr.length == 2)
					setVector2(loc, Value);
				else if (arr.length == 3)
					setVector3(loc, Value);
				else if (arr.length == 16)
					setMatrix4x4(loc, Value);
				else
					trace("Unknown uniform value array type passed: " + Name);
			}
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
	
	static private function setMatrix4x4(Location:GLUniformLocation, Value:Mat4)
	{
		GL.uniformMatrix4fv(Location, false, matrixToFloat32Array(Value));
	}
	
	static private function matrixToFloat32Array(M:Mat4):Float32Array
	{
		var arr:Array<Float> = [];
		for (i in 0...16)
		{
			arr.push(M[i]);
		}
		return new Float32Array(arr);
	}
}
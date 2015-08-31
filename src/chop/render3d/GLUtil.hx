package chop.render3d;

import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.GL.GLProgram;
import chop.render3d.opengl.GL.GLUniformLocation;
import chop.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class GLUtil
{
	static public function setUniformElement(Program:GLProgram, Name:String, Index:Int, Property:String, Value:Dynamic)
	{
		setUniform(Program, Name + "[" + Std.string(Index) + "]." + Property, Value);
	}
	
	static public function setUniform(Program:GLProgram, Name:String, Value:Dynamic)
	{
		var loc:GLUniformLocation = GL.getUniformLocation(Program, Name);
		var isOk:Bool = true;
		#if snow
		isOk = loc != null;
		#else
		isOk = loc >= 0;
		#end
		
		if (!isOk)
		{
			trace("Uniform " + Name + " location could not be found.");
		}
		else
		{
			//if (Std.is(Value, Int))
				//setInt(loc, Value);
			//else if (Std.is(Value, Float))
				//setFloat(loc, Value);
			//if (Std.is(Value, Float))
				//setFloat(loc, Value);
			//else if (Std.is(Value, Int))
				//setInt(loc, Value);
			//else if (Std.is(Value, Bool))
			if (Std.is(Value, Bool))
				setBool(loc, Value);
			else if (Std.is(Value, Vector3Type))
				setVector3(loc, Value);
			else if (Std.is(Value, Matrix4x4Type))
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
	
	static private function setVector3(Location:GLUniformLocation, Value:Vector3)
	{
		GL.uniform3f(Location, Value.x, Value.y, Value.z);
	}
	
	static private function setMatrix4x4(Location:GLUniformLocation, Value:Matrix4x4)
	{
		GL.uniformMatrix4fv(Location, false, matrixToFloat32Array(Value));
	}
	
	static private function matrixToFloat32Array(M:Matrix4x4):Float32Array
	{
		var arr:Array<Float> = [];
		for (i in 0...16)
		{
			arr.push(M.getArrayElement(i));
		}
		return new Float32Array(arr);
	}
}
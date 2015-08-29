package chop.render3d.shader;

import chop.render3d.opengl.GL;
import chop.render3d.opengl.GL.GLBuffer;
import chop.render3d.opengl.ChopGL;

/**
 * ...
 * @author Ohmnivore
 */
class ChopBuffer
{
	public var buffer:GLBuffer;
	public var target:Int;
	
	public function new() 
	{
		buffer = GL.createBuffer();
	}
	
	public function bind(Target:Int):Void
	{
		target = Target;
		GL.bindBuffer(target, buffer);
	}
}
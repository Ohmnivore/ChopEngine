package choprender.render3d.shader;

import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLBuffer;
import choprender.render3d.shaderexp.opengl.ChopGL;

/**
 * ...
 * @author Ohmnivore
 */
class ChopBuffer
{
	public var buffer:GLFramebuffer;
	public var target:Int;
	
	public function new() 
	{
		buffer = GL.createFramebuffer();
	}
	
	public function bind(Target:Int):Void
	{
		target = Target;
		GL.bindFramebuffer(target, buffer);
	}
	
	public function checkCompleteness():Void
	{
		if (GL.checkFramebufferStatus(target) != GL.FRAMEBUFFER_COMPLETE)
			throw("buffer incomplete " + GL.checkFramebufferStatus(GL.FRAMEBUFFER));
	}
	
	public function addDepthBuffer(Width:Int, Height:Int):Void
	{
		var rbo:GLRenderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, rbo);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT, Width, Height);
		GL.framebufferRenderbuffer(target, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, rbo);
	}
}
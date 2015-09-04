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
	public var buffer:GLFramebuffer;
	public var target:Int;
	public var attachmentIndex:Int;
	
	public function new() 
	{
		buffer = GL.createFramebuffer();
		attachmentIndex = 0;
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
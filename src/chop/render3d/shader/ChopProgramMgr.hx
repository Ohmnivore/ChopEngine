package chop.render3d.shader;

import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.opengl.GL;

/**
 * ...
 * @author Ohmnivore
 */
class ChopProgramMgr
{
	public var progs:Array<ChopProgram>;
	public var textures:Map<String, ChopTexture>;
	public var buff:ChopBuffer;
	
	public function new() 
	{
		progs = [];
		textures = new Map<String, ChopTexture>();
		
		buff = new ChopBuffer();
		buff.bind(GL.FRAMEBUFFER);
		
		var rbo:GLRenderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, rbo);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT, 640, 480);
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, rbo);
	}
	
	public function init():Void
	{
		var attachmentIndex:Int = 0;
		for (p in progs)
		{
			for (t in p.outTextures)
			{
				if (!textures.exists(t.name))
				{
					textures.set(t.name, t);
					t.addToBuffer(buff.target, attachmentIndex);
					attachmentIndex++;
				}
			}
		}
		
		if (GL.checkFramebufferStatus(GL.FRAMEBUFFER) != GL.FRAMEBUFFER_COMPLETE)
			throw("buffer incomplete " + GL.checkFramebufferStatus(GL.FRAMEBUFFER));
	}
	
	//public function render(M:Model, C:Camera):Void
	//{
		//for (p in progs)
		//{
			//p.preRender(this);
			//p.render(M, C, this);
		//}
	//}
}
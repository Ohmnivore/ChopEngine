package chop.render3d.shader;

import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.ChopGL_FFI;

/**
 * ...
 * @author Ohmnivore
 */
class ChopProgramMgr
{
	public var progs:Array<ChopProgram>;
	public var textures:Map<String, ChopTexture>;
	public var buff:ChopBuffer;
	
	public function new(C:Camera) 
	{
		progs = [];
		textures = new Map<String, ChopTexture>();
		
		buff = new ChopBuffer();
		buff.bind(GL.FRAMEBUFFER);
		buff.addDepthBuffer(C.width, C.height);
	}
	
	public function init():Void
	{
		for (p in progs)
		{
			for (t in p.outTextures)
			{
				if (!textures.exists(t.name))
				{
					t.buffer.bind(GL.FRAMEBUFFER);
					textures.set(t.name, t);
					t.addToBuffer();
				}
			}
			p.registerTextures(this);
		}
		
		for (t in textures)
		{
			t.buffer.bind(GL.FRAMEBUFFER);
			t.buffer.checkCompleteness();
		}
	}
}
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
	}
	
	public function init():Void
	{
		buff.bind(GL.FRAMEBUFFER);
		
		var attachmentIndex:Int = 0;
		for (p in progs)
		{
			for (t in p.outTextures)
			{
				if (!textures.exists(t.names.globalName))
				{
					textures.set(t.names.globalName, t);
					t.addToBuffer(buff.target, attachmentIndex);
					attachmentIndex++;
				}
			}
		}
	}
	
	public function render(M:Model, C:Camera):Void
	{
		for (p in progs)
		{
			p.preRender();
			p.render(M, C);
		}
	}
}
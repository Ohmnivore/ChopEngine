package choprender.render3d.shader;

import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;

/**
 * ...
 * @author Ohmnivore
 */
class ChopProgramMgr
{
	public var cam:Camera;
	public var progs:Array<ChopProgram>;
	public var textures:Map<String, ChopTexture>;
	public var buff:ChopBuffer;
	
	public function new(C:Camera) 
	{
		cam = C;
		progs = [];
		textures = new Map<String, ChopTexture>();
		
		buff = new ChopBuffer();
		buff.bind(GL.FRAMEBUFFER);
		buff.addDepthBuffer(cam.width, cam.height);
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
					//t.addToBuffer();
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
	
	public function preDraw(Elapsed:Float):Void
	{
		
	}
	
	public function postDraw(Elapsed:Float):Void
	{
		
	}
}
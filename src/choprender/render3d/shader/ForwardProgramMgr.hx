package choprender.render3d.shader;

import choprender.render3d.Camera;
import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.GL;
import choprender.model.Model;

/**
 * ...
 * @author Ohmnivore
 */
class ForwardProgramMgr extends ChopProgramMgr
{
	public var gLightProgram:ShaderForwardLights;
	
	public function new(C:Camera)
	{
		super(C);
		
		gLightProgram = new ShaderForwardLights(C);
		progs.push(gLightProgram);
		gLightProgram.gForwardLight.buffer = buff;
		gLightProgram.frameBuffer = buff.buffer;
		gLightProgram.outputToScreenBuffer();
		
		//var gaussianBlurProgram:ShaderGaussianBlur = new ShaderGaussianBlur(C);
		//progs.push(gaussianBlurProgram);
		//gaussianBlurProgram.frameBuffer = buff.buffer;
		//gaussianBlurProgram.inTextures[0].globalName = "gForwardLight";
		//gaussianBlurProgram.gGaussianBlur.buffer = buff;
		//var gaussianBlurVerticalProgram:ShaderGaussianBlur = new ShaderGaussianBlur(C);
		//gaussianBlurVerticalProgram.horizontal = false;
		//progs.push(gaussianBlurVerticalProgram);
		//gaussianBlurVerticalProgram.frameBuffer = buff.buffer;
		//gaussianBlurVerticalProgram.inTextures[0].globalName = "gGaussianBlur";
		//gaussianBlurVerticalProgram.gGaussianBlur.buffer = buff;
		//gaussianBlurVerticalProgram.outputToScreenBuffer();
		
		//var quadTextureProgram:ShaderQuadTexture = new ShaderQuadTexture(C);
		//progs.push(quadTextureProgram);
		//quadTextureProgram.frameBuffer = buff.buffer;
		//quadTextureProgram.outputToScreenBuffer();
		//quadTextureProgram.inTextures[0].globalName = "gForwardLight";
	}
	
	override public function preDraw(Elapsed:Float):Void 
	{
		super.preDraw(Elapsed);
		
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LEQUAL);
		GL.clearDepth(1.0);
		
		GL.enable(GL.BLEND);
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		
		GL.viewport(Std.int(cam.screenPos.x), Std.int(SnowApp._snow.window.height - cam.screenPos.y - cam.height), cam.width, cam.height);
		GL.clearColor(cam.bgColor.x, cam.bgColor.y, cam.bgColor.z, 1.0);
		GL.clear(GL.DEPTH_BUFFER_BIT);
	}
	
	override public function postDraw(Elapsed:Float):Void 
	{
		super.postDraw(Elapsed);
		
		for (p in progs)
		{
			if (p.type == ChopProgram.MULTIPLE)
			{
				var opaque:Array<Model> = [];
				var trans:Array<Model> = [];
				for (basic in GlobalRender.members)
				{
					if (Std.is(basic, Model))
					{
						var m:Model = cast basic;
						var isOpaque:Bool = true;
						for (mat in m.data.materials)
						{
							if (mat.transparency != 1.0)
							{
								isOpaque = false;
								break;
							}
						}
						if (isOpaque)
							opaque.push(m);
						else
							trans.push(m);
					}
				}
				p.preRender(this);
				p.render(opaque, cam, this);
				p.render(trans, cam, this);
			}
			else if (p.type == ChopProgram.ONESHOT)
			{
				p.preRender(this);
				p.render(null, cam, this);
			}
		}
		
		GL.disable(GL.CULL_FACE);
		GL.disable(GL.DEPTH_TEST);
	}
}
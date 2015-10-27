package choprender.render3d.shaderexp;

import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.shader.*;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.model.Model;

/**
 * ...
 * @author Ohmnivore
 */
class DeferredProgramMgr extends ChopProgramMgr
{
	public var gBufferProgram:ShaderGBuffer;
	public var gLightProgram:ShaderDeferredLights;
	public var toLumaProgram:ShaderRGBAToLuma;
	public var fxaaProgram:ShaderFXAA;
	
	public function new(C:Camera)
	{
		super(C);
		
		gBufferProgram = new ShaderGBuffer(C);
		progs.push(gBufferProgram);
		gBufferProgram.readBuffer = buff.buffer;
		gBufferProgram.drawBuffer = buff.buffer;
		gBufferProgram.gPosition.buffer = buff;
		gBufferProgram.gNormal.buffer = buff;
		gBufferProgram.gDiffuse.buffer = buff;
		gBufferProgram.gSpec.buffer = buff;
		gBufferProgram.gRealPosition.buffer = buff;
		gBufferProgram.gUV.buffer = buff;
		
		gLightProgram = new ShaderDeferredLights(C);
		progs.push(gLightProgram);
		gLightProgram.readBuffer = buff.buffer;
		gLightProgram.drawBuffer = buff.buffer;
		gLightProgram.gLight.buffer = buff;
		//gLightProgram.outputToScreenBuffer();
		
		toLumaProgram = new ShaderRGBAToLuma(C);
		progs.push(toLumaProgram);
		toLumaProgram.readBuffer = buff.buffer;
		toLumaProgram.drawBuffer = buff.buffer;
		toLumaProgram.inTextures[0].globalName = "gLight";
		toLumaProgram.gLuma.buffer = buff;
		
		fxaaProgram = new ShaderFXAA(C);
		progs.push(fxaaProgram);
		fxaaProgram.readBuffer = buff.buffer;
		fxaaProgram.drawBuffer = buff.buffer;
		fxaaProgram.inTextures[0].globalName = "gLuma";
		fxaaProgram.gFXAA.buffer = buff;
		fxaaProgram.outputToScreenBuffer();
		
		//var gaussianBlurProgram:ShaderGaussianBlur = new ShaderGaussianBlur(this);
		//defaultMgr.progs.push(gaussianBlurProgram);
		//gaussianBlurProgram.readBuffer = defaultMgr.buff.buffer;
		//gaussianBlurProgram.drawBuffer = defaultMgr.buff.buffer;
		//gaussianBlurProgram.inTextures[0].globalName = "gFXAA";
		//gaussianBlurProgram.gGaussianBlur.buffer = defaultMgr.buff;
		//var gaussianBlurVerticalProgram:ShaderGaussianBlur = new ShaderGaussianBlur(this);
		//gaussianBlurVerticalProgram.horizontal = false;
		//defaultMgr.progs.push(gaussianBlurVerticalProgram);
		//gaussianBlurVerticalProgram.readBuffer = defaultMgr.buff.buffer;
		//gaussianBlurVerticalProgram.drawBuffer = new GLFramebuffer(0);
		//gaussianBlurVerticalProgram.inTextures[0].globalName = "gGaussianBlur";
		//gaussianBlurVerticalProgram.outTextures = [];
		//gaussianBlurVerticalProgram.gGaussianBlur.buffer = defaultMgr.buff;
		
		//var quadTextureProgram:ShaderQuadTexture = new ShaderQuadTexture(C);
		//progs.push(quadTextureProgram);
		//quadTextureProgram.readBuffer = buff.buffer;
		//quadTextureProgram.outputToScreenBuffer();
		//quadTextureProgram.inTextures[0].globalName = "gUV";
	}
	
	override public function preDraw(Elapsed:Float):Void 
	{
		super.preDraw(Elapsed);
		
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LEQUAL);
		GL.clearDepth(1.0);
		
		//GL.enable(GL.BLEND);
		//GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		
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
				//var trans:Array<Model> = [];
				for (basic in GlobalRender.members)
				{
					if (Std.is(basic, Model))
					{
						var m:Model = cast basic;
						//var isOpaque:Bool = true;
						//for (mat in m.data.materials)
						//{
							//if (mat.transparency != 1.0)
							//{
								//isOpaque = false;
								//break;
							//}
						//}
						//if (isOpaque)
							opaque.push(m);
						//else
							//trans.push(m);
					}
				}
				p.preRender(this);
				p.render(opaque, cam, this);
				//p.render(trans, cam, this);
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
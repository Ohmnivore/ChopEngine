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
	public var skyBoxLegacyProgram:ShaderSkyBoxLegacy;
	public var gLightProgram:ShaderForwardLights;
	
	public function new(C:Camera)
	{
		super(C);
		
		skyBoxLegacyProgram = new ShaderSkyBoxLegacy(C);
		progs.push(skyBoxLegacyProgram);
		skyBoxLegacyProgram.gSkyBoxLegacy.buffer = buff;
		skyBoxLegacyProgram.frameBuffer = buff.buffer;
		skyBoxLegacyProgram.outputToScreenBuffer();
		
		gLightProgram = new ShaderForwardLights(C);
		progs.push(gLightProgram);
		gLightProgram.gForwardLight.buffer = buff;
		gLightProgram.frameBuffer = buff.buffer;
		gLightProgram.outputToScreenBuffer();
		
		//var normalOutputProgram:ShaderNormalOutput = new ShaderNormalOutput(cam);
		//progs.push(normalOutputProgram);
		//normalOutputProgram.frameBuffer = buff.buffer;
		//normalOutputProgram.gNormal.buffer = buff;
		////normalOutputProgram.outputToScreenBuffer();
		//
		//var positionOutputProgram:ShaderPositionOutput = new ShaderPositionOutput(cam);
		//progs.push(positionOutputProgram);
		//positionOutputProgram.frameBuffer = buff.buffer;
		//positionOutputProgram.gPosition.buffer = buff;
		////positionOutputProgram.outputToScreenBuffer();
		//
		//var ssaoProgram:ShaderSSAO = new ShaderSSAO(cam);
		//progs.push(ssaoProgram);
		//ssaoProgram.frameBuffer = buff.buffer;
		//ssaoProgram.gSSAO.buffer = buff;
		//ssaoProgram.texNoise.buffer = buff;
		////ssaoProgram.outputToScreenBuffer();
		//
		//var gaussianBlurProgram:ShaderGaussianBlur = new ShaderGaussianBlur(C);
		//gaussianBlurProgram.blurSize = 16;
		//gaussianBlurProgram.sigma = 4;
		//progs.push(gaussianBlurProgram);
		//gaussianBlurProgram.frameBuffer = buff.buffer;
		//gaussianBlurProgram.inTextures[0].globalName = "gSSAO";
		//gaussianBlurProgram.gGaussianBlur.buffer = buff;
		//var gaussianBlurVerticalProgram:ShaderGaussianBlur = new ShaderGaussianBlur(C);
		//gaussianBlurVerticalProgram.blurSize = 16;
		//gaussianBlurVerticalProgram.sigma = 4;
		//gaussianBlurVerticalProgram.horizontal = false;
		//progs.push(gaussianBlurVerticalProgram);
		//gaussianBlurVerticalProgram.frameBuffer = buff.buffer;
		//gaussianBlurVerticalProgram.gGaussianBlur.name = "gGaussianBlurV";
		//gaussianBlurVerticalProgram.inTextures[0].globalName = "gGaussianBlur";
		//gaussianBlurVerticalProgram.gGaussianBlur.buffer = buff;
		////gaussianBlurVerticalProgram.outputToScreenBuffer();
		//
		//var gSSAOBlendProgram:ShaderSSAOBlend = new ShaderSSAOBlend(cam);
		//progs.push(gSSAOBlendProgram);
		//gSSAOBlendProgram.frameBuffer = buff.buffer;
		//gSSAOBlendProgram.blended.buffer = buff;
		////gSSAOBlendProgram.outputToScreenBuffer();
		//
		//var toLumaProgram:ShaderRGBAToLuma = new ShaderRGBAToLuma(C);
		//progs.push(toLumaProgram);
		//toLumaProgram.frameBuffer = buff.buffer;
		//toLumaProgram.inTextures[0].globalName = "blended";
		//toLumaProgram.gLuma.buffer = buff;
		//
		//var fxaaProgram:ShaderFXAA = new ShaderFXAA(C);
		//progs.push(fxaaProgram);
		//fxaaProgram.frameBuffer = buff.buffer;
		//fxaaProgram.inTextures[0].globalName = "gLuma";
		//fxaaProgram.gFXAA.buffer = buff;
		//fxaaProgram.outputToScreenBuffer();
		
		//var gSSAOLightProgram:ShaderSSAOForwardLights = new ShaderSSAOForwardLights(C);
		//progs.push(gSSAOLightProgram);
		//gSSAOLightProgram.gForwardLight.buffer = buff;
		//gSSAOLightProgram.frameBuffer = buff.buffer;
		//gSSAOLightProgram.inTextures[0].globalName = "gGaussianBlurV";
		//gSSAOLightProgram.outputToScreenBuffer();
		
		//var quadTextureProgram:ShaderQuadTexture = new ShaderQuadTexture(C);
		//progs.push(quadTextureProgram);
		//quadTextureProgram.frameBuffer = buff.buffer;
		//quadTextureProgram.inTextures[0].globalName = "gGaussianBlurV";
		//quadTextureProgram.outputToScreenBuffer();
	}
	
	override public function preDraw(Elapsed:Float):Void 
	{
		super.preDraw(Elapsed);
		
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LEQUAL);
		GL.clearDepth(1.0);
		
		cam.setViewport();
		GL.enable(GL.SCISSOR_TEST);
		cam.setScissor();
		GL.clearColor(cam.bgColor.x, cam.bgColor.y, cam.bgColor.z, 1.0);
		
		if (cam.shouldClearColor && cam.shouldClearDepth)
			GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		else if (cam.shouldClearColor)
			GL.clear(GL.COLOR_BUFFER_BIT);
		else if (cam.shouldClearDepth)
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
					if (Std.is(basic, Model) && cast(basic, Model).cams.indexOf(cam) >= 0)
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
				p.postRender(this);
			}
			else if (p.type == ChopProgram.ONESHOT)
			{
				p.preRender(this);
				p.render(null, cam, this);
				p.postRender(this);
			}
		}
		
		GL.disable(GL.CULL_FACE);
		GL.disable(GL.DEPTH_TEST);
		GL.disable(GL.SCISSOR_TEST);
	}
}
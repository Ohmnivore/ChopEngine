package choprender.render3d.shader;
import choprender.render3d.Camera;

/**
 * ...
 * @author Ohmnivore
 */
class DefaultProgramMgr extends ChopProgramMgr
{
	public var gBufferProgram:ShaderGBuffer;
	public var gLightProgram:ShaderLights;
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
		
		gLightProgram = new ShaderLights(C);
		progs.push(gLightProgram);
		gLightProgram.readBuffer = buff.buffer;
		gLightProgram.drawBuffer = buff.buffer;
		gLightProgram.gLight.buffer = buff;
		
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
		
		//var ssaoShader = new ShaderSSAO(this);
		//defaultMgr.progs.push(ssaoShader);
		//ssaoShader.readBuffer = defaultMgr.buff.buffer;
		//ssaoShader.drawBuffer = new GLFramebuffer(0);
		//ssaoShader.outTextures = [];
		//ssaoShader.gSSAO.buffer = defaultMgr.buff;
		//ssaoShader.texNoise.buffer = defaultMgr.buff;
		
		//var newBuff:ChopBuffer = new ChopBuffer();
		//newBuff.bind(GL.FRAMEBUFFER);
		//var rbo:GLRenderbuffer = GL.createRenderbuffer();
		//GL.bindRenderbuffer(GL.RENDERBUFFER, rbo);
		//GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT, width, height);
		//GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, rbo);
		//ssaoShader.texNoise.buffer = newBuff;
		//ssaoShader.readBuffer = newBuff.buffer;
		
		//var quadTextureProgram:ShaderQuadTexture = new ShaderQuadTexture(C);
		//progs.push(quadTextureProgram);
		//quadTextureProgram.readBuffer = buff.buffer;
		//quadTextureProgram.outputToScreenBuffer();
		//quadTextureProgram.inTextures[0].globalName = "gUV";
	}
}
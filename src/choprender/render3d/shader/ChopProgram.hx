package choprender.render3d.shader;

import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.ChopGL_FFI;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.GLUtil;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.assets.Assets;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ChopProgram
{
	static public inline var MULTIPLE:Int = 0;
	static public inline var ONESHOT:Int = 1;
	static public inline var SINGLE:Int = 2;
	
	public var inTextures:Array<ChopTextureDescriptor>;
	public var outTextures:Array<ChopTexture>;
	public var prog:GLProgram;
	public var readBuffer:GLFramebuffer;
	public var drawBuffer:GLFramebuffer;
	public var type:Int;
	
	public function new(C:Camera) 
	{
		prog = GL.createProgram();
		
		inTextures = [];
		outTextures = [];
	}
	
	public function outputToScreenBuffer():Void
	{
		drawBuffer = new GLFramebuffer(0);
		outTextures = [];
	}
	
	public function registerTextures(Mgr:ChopProgramMgr):Void
	{
		
	}
	
	public function preRender(Mgr:ChopProgramMgr):Void
	{
		GL.useProgram(prog);
		bindInTextures(Mgr);
		
		GL.bindFramebuffer(ChopGL.READ_FRAMEBUFFER, readBuffer);
		GL.bindFramebuffer(ChopGL.DRAW_FRAMEBUFFER, drawBuffer);
		
		bindOutTextures(Mgr);
	}
	
	public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void
	{
		
	}
	
	private function bindOutTextures(Mgr:ChopProgramMgr):Void
	{
		var texAttachmentIds:Array<Int> = [];
		for (t in outTextures)
		{
			texAttachmentIds.push(t.colorAttachmentGL);
		}
		if (texAttachmentIds.length > 0)
			ChopGL_FFI.drawBuffers(texAttachmentIds.length, texAttachmentIds);
	}
	
	private function bindInTextures(Mgr:ChopProgramMgr):Void
	{
		for (i in 0...inTextures.length)
		{
			GL.activeTexture(textureIDToGL(i));
			var texDescr:ChopTextureDescriptor = inTextures[i];
			var tex:ChopTexture = Mgr.textures.get(texDescr.globalName);
			GL.bindTexture(tex.target, tex.texture);
			GLUtil.setInt(GLUtil.getLocation(prog, texDescr.shaderName), i);
		}
	}
	
	private static function textureIDToGL(ID:Int):Int
	{
		if (ID == 0)
			return GL.TEXTURE0;
		else if (ID == 1)
			return GL.TEXTURE1;
		else if (ID == 2)
			return GL.TEXTURE2;
		else if (ID == 3)
			return GL.TEXTURE3;
		else if (ID == 4)
			return GL.TEXTURE4;
		else if (ID == 5)
			return GL.TEXTURE5;
		else if (ID == 6)
			return GL.TEXTURE6;
		else if (ID == 8)
			return GL.TEXTURE7;
		else if (ID == 9)
			return GL.TEXTURE9;
		else if (ID == 10)
			return GL.TEXTURE10;
		else if (ID == 11)
			return GL.TEXTURE11;
		else if (ID == 12)
			return GL.TEXTURE12;
		else if (ID == 13)
			return GL.TEXTURE13;
		else if (ID == 14)
			return GL.TEXTURE14;
		else if (ID == 15)
			return GL.TEXTURE15;
		else
			throw "Invaid texture index";
	}
}
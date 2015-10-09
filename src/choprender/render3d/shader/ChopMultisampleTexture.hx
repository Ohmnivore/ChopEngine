package choprender.render3d.shader;

import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.ChopGL_FFI;

/**
 * ...
 * @author Ohmnivore
 */
class ChopMultisampleTexture extends ChopTexture
{
	public var fixedSampleLocation:Bool = true;
	
	override public function addToBuffer(Target:Int, Attachment:Int):Void
	{
		colorAttachment = Attachment;
		colorAttachmentGL = ChopTexture.intToColorAttachment(colorAttachment);
		
		texture = GL.createTexture();
		GL.bindTexture(target, texture);
		ChopGL_FFI.texImage2DMultisample(target, level, internalFormat, width, height, fixedSampleLocation);
		for (p in params)
			p.addToTexture(this);
		GL.framebufferTexture2D(Target, colorAttachmentGL, target, texture, 0);
	}
}
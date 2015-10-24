package choprender.render3d.shader;

import choprender.render3d.opengl.GL;
import choprender.render3d.shaderexp.opengl.ChopGL;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ChopTexture
{
	public var texture:GLTexture;
	public var name:String;
	public var colorAttachment:Int;
	public var colorAttachmentGL:Int;
	
	public var target:Int;
	public var level:Int;
	public var internalFormat:Int;
	public var width:Int;
	public var height:Int;
	public var format:Int;
	public var type:Int;
	public var pixels:ArrayBufferView;
	public var buffer:ChopBuffer;
	
	public var params:Array<ChopTextureParam>;
	
	static public function intToColorAttachment(I:Int):Int
	{
		if (I == 0)
			return ChopGL.COLOR_ATTACHMENT0;
		else if (I == 1)
			return ChopGL.COLOR_ATTACHMENT1;
		else if (I == 2)
			return ChopGL.COLOR_ATTACHMENT2;
		else if (I == 3)
			return ChopGL.COLOR_ATTACHMENT3;
		else if (I == 4)
			return ChopGL.COLOR_ATTACHMENT4;
		else if (I == 5)
			return ChopGL.COLOR_ATTACHMENT5;
		else if (I == 6)
			return ChopGL.COLOR_ATTACHMENT6;
		else if (I == 7)
			return ChopGL.COLOR_ATTACHMENT7;
		else if (I == 8)
			return ChopGL.COLOR_ATTACHMENT8;
		else if (I == 9)
			return ChopGL.COLOR_ATTACHMENT9;
		else if (I == 10)
			return ChopGL.COLOR_ATTACHMENT10;
		else if (I == 11)
			return ChopGL.COLOR_ATTACHMENT11;
		else if (I == 12)
			return ChopGL.COLOR_ATTACHMENT12;
		else if (I == 13)
			return ChopGL.COLOR_ATTACHMENT13;
		else if (I == 14)
			return ChopGL.COLOR_ATTACHMENT14;
		else if (I == 15)
			return ChopGL.COLOR_ATTACHMENT15;
		else
			throw("Invaid color attachment index");
	}
	
	public function new(Name:String, Target:Int, Level:Int, InternalFormat:Int, Width:Int, Height:Int, Format:Int, T:Int, Pixels:ArrayBufferView = null)
	{
		texture = GL.createTexture();
		
		name = Name;
		target = Target;
		level = Level;
		internalFormat = InternalFormat;
		width = Width;
		height = Height;
		format = Format;
		type = T;
		pixels = Pixels;
		
		params = [];
	}
	
	//public function addToBuffer(Target:Int, Attachment:Int):Void
	//{
		//colorAttachment = Attachment;
		//colorAttachmentGL = intToColorAttachment(colorAttachment);
		//
		//GL.bindTexture(target, texture);
		//GL.texImage2D(target, level, internalFormat, width, height, 0, format, type, pixels);
		//for (p in params)
			//p.addToTexture(this);
		//GL.framebufferTexture2D(Target, colorAttachmentGL, target, texture, 0);
	//}
	
	public function create():Void
	{
		GL.bindTexture(target, texture);
		GL.texImage2D(target, level, internalFormat, width, height, 0, format, type, pixels);
		for (p in params)
			p.addToTexture(this);
	}
	
	public function addToBuffer():Void
	{
		colorAttachment = buffer.attachmentIndex;
		buffer.attachmentIndex++;
		colorAttachmentGL = intToColorAttachment(colorAttachment);
		
		create();
		GL.framebufferTexture2D(buffer.target, colorAttachmentGL, target, texture, 0);
	}
}
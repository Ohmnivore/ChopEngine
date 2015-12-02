package choprender.render3d.opengl;

import choprender.render3d.opengl.ChopBuffer;
import choprender.render3d.opengl.GL;
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
	
	public function create():Void
	{
		GL.bindTexture(target, texture);
		GL.texImage2D(target, level, internalFormat, width, height, 0, format, type, pixels);
		updateParams();
	}
	
	public function image2D(Target:Int, Width:Int, Height:Int, Pixels:ArrayBufferView = null)
	{
		GL.texImage2D(Target, level, internalFormat, Width, Height, 0, format, type, Pixels);
	}
	
	public function updateParams():Void
	{
		for (p in params)
			p.addToTexture(this);
	}
	
	public function addToBuffer():Void
	{
		GL.framebufferTexture2D(buffer.target, GL.COLOR_ATTACHMENT0, target, texture, level);
	}
}
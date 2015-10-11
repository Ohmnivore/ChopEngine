package choprender.text;

import chop.math.Vec2;
import chop.math.Vec4;
import choprender.model.data.Bitmap;
import choprender.model.data.Texture;
import choprender.model.QuadModel;
import choprender.text.loader.FontBuilderNGL.Font;
import choprender.text.loader.FontBuilderNGL.FontChar;
import snow.api.buffers.ArrayBufferIO;
import snow.api.buffers.ArrayBuffer;
import choprender.render3d.opengl.GL.Uint8Array;

/**
 * ...
 * @author Ohmnivore
 */
class Text extends QuadModel
{
	static private inline var UNKNOWN_REPLACER:String = " ";
	
	public var font:Font;
	
	public function new(F:Font) 
	{
		super();
		font = F;
		mat.useShading = false;
		mat.diffuseColor.set(0, 0, 0);
	}
	
	public function setText(T:String):Void
	{
		var chars:Array<FontChar> = [];
		for (i in 0...T.length)
		{
			var c:String = T.charAt(i);
			if (font.chars.exists(c))
				chars.push(font.chars.get(c));
			else
				chars.push(font.chars.get(UNKNOWN_REPLACER));
		}
		setChars(chars);
	}
	
	private function setChars(Chars:Array<FontChar>):Void
	{
		var b:Bitmap = new Bitmap();
		for (c in Chars)
		{
			b.setSize(b.width + c.advance - c.offsetX, 16);
			b.copyPixels(
				font.tex,
				b,
				Vec4.fromValues(c.rectX, c.rectY, c.rectWidth, c.rectHeight),
				Vec2.fromValues(b.width - c.advance + c.offsetX, 8 - c.offsetY)
			);
		}
		loadTexData(b.pixels, b.width, b.height);
		scale.x = b.width / b.height;
	}
}
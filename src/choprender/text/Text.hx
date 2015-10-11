package choprender.text;

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
	public var font:Font;
	
	public function new(F:Font) 
	{
		super();
		font = F;
	}
	
	public function setText(T:String):Void
	{
		if (font.chars.exists(T))
		{
			setChar(font.chars.get(T.charAt(0)));
		}
	}
	
	private function setChar(C:FontChar):Void
	{
		var arr:Array<Int> = [];
		for (y in 0...C.rectHeight)
		{
			for (x in 0...C.rectWidth)
			{
				var arrB:ArrayBuffer = cast font.tex.pixels.buffer;
				arr.push(ArrayBufferIO.getUint8(arrB, (C.rectY + y) * font.tex.width * 4 + (x + C.rectX) * 4 + 0));
				arr.push(ArrayBufferIO.getUint8(arrB, (C.rectY + y) * font.tex.width * 4 + (x + C.rectX) * 4 + 1));
				arr.push(ArrayBufferIO.getUint8(arrB, (C.rectY + y) * font.tex.width * 4 + (x + C.rectX) * 4 + 2));
				arr.push(ArrayBufferIO.getUint8(arrB, (C.rectY + y) * font.tex.width * 4 + (x + C.rectX) * 4 + 3));
			}
		}
		loadTexData(new Uint8Array(arr), C.rectWidth, C.rectHeight);
	}
}
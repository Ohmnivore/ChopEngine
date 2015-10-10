package choprender.text;

import choprender.model.QuadModel;
import choprender.text.loader.FontBuilderNGL.Font;
import choprender.text.loader.FontBuilderNGL.FontChar;
import snow.api.buffers.ArrayBufferIO;

/**
 * ...
 * @author Ohmnivore
 */
class Text extends QuadModel
{
	public var font:Font;
	
	public function new(F:Font) 
	{
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
				arr.push(ArrayBufferIO.getUint8(font.tex, y * font.texWidth + x));
			}
		}
	}
}
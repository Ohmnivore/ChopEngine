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
	public var textWidth:Int;
	public var wordWrap:Bool;
	public var alignment:String;
	
	public function new(F:Font) 
	{
		super();
		font = F;
		textWidth = -1;
		wordWrap = false;
		alignment = "";
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
			else if (c == "\n")
				chars.push(null);
			else
				chars.push(font.chars.get(UNKNOWN_REPLACER));
		}
		setChars(chars);
	}
	
	private function setChars(Chars:Array<FontChar>):Void
	{
		var b:Bitmap = new Bitmap();
		if (textWidth == -1)
			b.setSize(0, 0);
		else
			b.setSize(textWidth, 0);
		var x:Int = 0;
		var y:Int = 0;
		for (i in 0...Chars.length)
		{
			var c:FontChar = Chars[i];
			var lastC:FontChar = null;
			if (i > 0)
				lastC = Chars[i - 1];
			var nextC:FontChar = null;
			if (i < Chars.length - 1)
				nextC = Chars[i + 1];
			var display:Bool = true;
			var newLine:Bool = false;
			
			if ((c == null) || // newline
				(textWidth != -1 && !wordWrap && nextC != null && b.width < x + c.advance) // char wrap
			)
			{
				newLine = true;
				display = c != null;
			}
			if (textWidth != -1 && wordWrap && (lastC == null || lastC.id == " ") && c != null && c.id != " ") // word wrap
			{
				var curWidth:Int = 0;
				var j:Int = 0;
				while (j + i < Chars.length)
				{
					var nextC:FontChar = Chars[i + j];
					if (nextC == null || nextC.id == " ")
						break;
					curWidth += nextC.advance; 
					j++;
				}
				if (b.width < x + curWidth)
				{
					newLine = true;
				}
			}
			if (newLine)
			{
				y += font.size;
				x = 0;
			}
			if (display)
			{
				var xDelta:Int = c.rectWidth;
				var yDelta:Int = font.size - c.offsetY + c.rectHeight;
				if (x + xDelta > b.width)
					b.setSize(x + xDelta, b.height);
				if (y + yDelta > b.height)
					b.setSize(b.width, y + yDelta);
					
				b.copyPixels(
					font.tex,
					b,
					Vec4.fromValues(c.rectX, c.rectY, c.rectWidth, c.rectHeight),
					Vec2.fromValues(x, y + font.size - c.offsetY)
				);
				x += c.advance;
			}
		}
		loadTexData(b.pixels, b.width, b.height);
		scale.x = b.width / b.height;
		scale.y = b.height / b.width;
		
		textWidth = b.width;
	}
}
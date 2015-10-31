package choprender.text;

import chop.math.Vec2;
import chop.math.Vec4;
import choprender.model.data.Bitmap;
import choprender.model.data.Texture;
import choprender.model.QuadModel;
import choprender.text.loader.FontBuilderNGL.Font;
import choprender.text.loader.FontBuilderNGL.FontChar;
import snow.api.buffers.ArrayBuffer;
import choprender.render3d.opengl.GL.Uint8Array;

/**
 * ...
 * @author Ohmnivore
 */
class Text extends QuadModel
{
	static public inline var ALIGN_LEFT:Int = 0;
	static public inline var ALIGN_CENTER:Int = 1;
	static public inline var ALIGN_RIGHT:Int = 2;
	
	static public inline var AUTO_WIDTH:Int = 0;
	static public inline var CHAR_WRAP:Int = 1;
	static public inline var WORD_WRAP:Int = 2;
	
	static private inline var UNKNOWN_REPLACER:String = " ";
	
	public var font:Font;
	
	public var alignment:Int;
	public var mode:Int;
	public var maxWidth:Float;
	public var fontSize:Float;
	
	public var textWidth:Int;
	public var textHeight:Int;
	
	public var text:String;
	
	public function new(F:Font) 
	{
		super();
		font = F;
		textWidth = 0;
		textHeight = 0;
		alignment = ALIGN_LEFT;
		mode = AUTO_WIDTH;
		maxWidth = 0;
		text = "";
		mat.useShading = false;
		mat.diffuseColor.set(0, 0, 0);
	}
	
	public function setMetrics(Mode:Int, Alignment:Int, FontSize:Float, MaxWidth:Float):Void
	{
		mode = Mode;
		alignment = Alignment;
		fontSize = FontSize;
		maxWidth = MaxWidth;
	}
	
	public function setText(T:String):Void
	{
		text = T;
		
		var b:Bitmap = new Bitmap();
		b.setSize(cast maxWidth, 0);
		
		var line:Line = new Line(this, b, 0);
		
		for (i in 0...text.length)
		{
			var c:String = text.charAt(i);
			if (c == "\n" || c == "\r")
			{
				line = new Line(this, b, line.yOffset + line.getHeight());
			}
			else
			{
				var char:FontChar = font.chars.get(UNKNOWN_REPLACER);
				if (font.chars.exists(c))
					char = font.chars.get(c);
				if (line.hasSpaceFor(char))
					line.addCharacter(char);
				else
					line = new Line(this, b, line.yOffset + line.getHeight());
			}
		}
		
		loadTexData(b.pixels, b.width, b.height);
		
		textWidth = b.width;
		textHeight = b.height;
		
		var d:Float = fontSize / font.size;
		setSize(textWidth * d, textHeight * d);
	}
	
	//public function setText(T:String, FontSize:Float):Void
	//{
		//fontSize = FontSize;
		//
		//var chars:Array<FontChar> = [];
		//for (i in 0...T.length)
		//{
			//var c:String = T.charAt(i);
			//if (font.chars.exists(c))
				//chars.push(font.chars.get(c));
			//else if (c == "\n")
				//chars.push(null);
			//else
				//chars.push(font.chars.get(UNKNOWN_REPLACER));
		//}
		//setChars(chars);
	//}
	//
	//private function setChars(Chars:Array<FontChar>):Void
	//{
		//var b:Bitmap = new Bitmap();
		//if (textWidth == AUTO_WIDTH)
			//b.setSize(0, 0);
		//else
			//b.setSize(textWidth, 0);
		//var x:Int = 0;
		//var y:Int = 0;
		//for (i in 0...Chars.length)
		//{
			//var c:FontChar = Chars[i];
			//var lastC:FontChar = null;
			//if (i > 0)
				//lastC = Chars[i - 1];
			//var nextC:FontChar = null;
			//if (i < Chars.length - 1)
				//nextC = Chars[i + 1];
			//var display:Bool = true;
			//var newLine:Bool = false;
			//
			//if ((c == null) || // newline
				//(textWidth != AUTO_WIDTH && !wordWrap && nextC != null && b.width < x + c.advance) // char wrap
			//)
			//{
				//newLine = true;
				//display = c != null;
			//}
			//if (textWidth != AUTO_WIDTH && wordWrap && (lastC == null || lastC.id == " ") && c != null && c.id != " ") // word wrap
			//{
				//var curWidth:Int = 0;
				//var j:Int = 0;
				//while (j + i < Chars.length)
				//{
					//var nextC:FontChar = Chars[i + j];
					//if (nextC == null || nextC.id == " ")
						//break;
					//curWidth += nextC.advance; 
					//j++;
				//}
				//if (b.width < x + curWidth)
				//{
					//newLine = true;
				//}
			//}
			//if (newLine)
			//{
				//y += font.size;
				//x = 0;
			//}
			//if (display)
			//{
				//var xDelta:Int = c.rectWidth;
				//var yDelta:Int = font.size - c.offsetY + c.rectHeight;
				//if (x + xDelta > b.width)
					//b.setSize(x + xDelta, b.height);
				//if (y + yDelta > b.height)
					//b.setSize(b.width, y + yDelta);
					//
				//b.copyPixels(
					//font.tex,
					//b,
					//Vec4.fromValues(c.rectX, c.rectY, c.rectWidth, c.rectHeight),
					//Vec2.fromValues(x, y + font.size - c.offsetY)
				//);
				//x += c.advance;
			//}
		//}
		//loadTexData(b.pixels, b.width, b.height);
		//
		//textWidth = b.width;
		//textHeight = b.height;
		//
		//var d:Float = fontSize / font.size;
		//setSize(textWidth * d, textHeight * d);
	//}
}
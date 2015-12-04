package choprender.text;

import chop.math.Vec2;
import chop.math.Vec4;
import choprender.model.data.Bitmap;
import choprender.model.data.Texture;
import choprender.model.QuadModel;
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
	
	public var font:Font;
	
	public var mode:Int;
	public var alignment:Int;
	public var maxWidthPixel:Int;
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
		mode = AUTO_WIDTH;
		alignment = ALIGN_LEFT;
		maxWidth = 0;
		maxWidthPixel = 0;
		text = "";
		mat.useShading = false;
		mat.diffuseColor.set(0, 0, 0);
		mat.transparency = 0.99;
	}
	
	public function setMetrics(Mode:Int, Alignment:Int, FontSize:Float, MaxWidth:Float = 0):Void
	{
		mode = Mode;
		alignment = Alignment;
		fontSize = FontSize;
		maxWidth = MaxWidth;
		maxWidthPixel = Std.int(maxWidth * font.size / FontSize);
	}
	
	public function setText(T:String):Void
	{
		text = T;
		
		var b:Bitmap = new Bitmap();
		b.setSize(maxWidthPixel, 0);
		
		var line:Line = new Line(this, b, 0);
		
		if (mode == WORD_WRAP)
		{
			var words:Array<String> = text.split(" ");
			for (i in 0...words.length)
			{
				var w:String = words[i];
				if (!line.hasSpaceForWord(w))
					line = getNewLine(line, b);
				if (i < words.length - 1) // Add back the space
					w += " ";
				for (i in 0...w.length)
				{
					var c:String = w.charAt(i);
					var char:FontChar = TextUtil.getChar(font, c);
					if (TextUtil.isNewline(c))
						line = getNewLine(line, b);
					else if (line.hasSpaceFor(char)) // Check if the added trailing space can actually be rendered
						line.addCharacter(char);
				}
			}
		}
		else
		{
			var fline = new FakeLine(this, maxWidthPixel, 0, 0);
			var flines:Array<FakeLine> = [fline];
			for (i in 0...text.length)
			{
				var c:String = text.charAt(i);
				if (TextUtil.isNewline(c))
				{
					fline = getNewFLine(fline);
					flines.push(fline);
				}
				else
				{
					var char:FontChar = TextUtil.getChar(font, c);
					if (!fline.hasSpaceFor(char))
					{
						fline = getNewFLine(fline);
						flines.push(fline);
					}
					fline.addCharacter(char);
				}
			}
			
			var maxDrawWidth:Int = fline.width;
			b.setSize(maxDrawWidth, b.height);
			var curLineIndex:Int = 0;
			line.xOffset = flines[curLineIndex++].getXOffset(maxDrawWidth);
			for (i in 0...text.length)
			{
				var c:String = text.charAt(i);
				if (TextUtil.isNewline(c))
				{
					line = getNewLine(line, b);
					line.xOffset = flines[curLineIndex++].getXOffset(maxDrawWidth);
				}
				else
				{
					var char:FontChar = TextUtil.getChar(font, c);
					if (!line.hasSpaceFor(char))
					{
						line = getNewLine(line, b);
						line.xOffset = flines[curLineIndex++].getXOffset(maxDrawWidth);
					}
					line.addCharacter(char);
				}
			}
		}
		
		loadTexData(b.pixels, b.width, b.height);
		tex.blendMode = Texture.BLEND_DST_IN;
		
		textWidth = b.width;
		textHeight = b.height;
		
		var d:Float = fontSize / font.size;
		setSize(textWidth * d, textHeight * d);
	}
	
	private function getNewLine(Old:Line, B:Bitmap):Line
	{
		return new Line(this, B, Old.yOffset + Old.getHeight());
	}
	private function getNewFLine(Old:FakeLine):FakeLine
	{
		return new FakeLine(this, Old.width, Old.height, Old.yOffset + Old.getHeight());
	}
}
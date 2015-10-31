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
	//static public inline var ALIGN_LEFT:Int = 0;
	//static public inline var ALIGN_CENTER:Int = 1;
	//static public inline var ALIGN_RIGHT:Int = 2;
	
	static public inline var AUTO_WIDTH:Int = 0;
	static public inline var CHAR_WRAP:Int = 1;
	static public inline var WORD_WRAP:Int = 2;
	
	public var font:Font;
	
	public var mode:Int;
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
		maxWidth = 0;
		maxWidthPixel = 0;
		text = "";
		mat.useShading = false;
		mat.diffuseColor.set(0, 0, 0);
	}
	
	public function setMetrics(Mode:Int, FontSize:Float, MaxWidth:Float = 0):Void
	{
		mode = Mode;
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
					line = line = getNewLine(line, b);
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
			for (i in 0...text.length)
			{
				var c:String = text.charAt(i);
				if (TextUtil.isNewline(c))
					line = getNewLine(line, b);
				else
				{
					var char:FontChar = TextUtil.getChar(font, c);
					if (!line.hasSpaceFor(char))
						line = getNewLine(line, b);
					line.addCharacter(char);
				}
			}
		}
		
		loadTexData(b.pixels, b.width, b.height);
		
		textWidth = b.width;
		textHeight = b.height;
		
		var d:Float = fontSize / font.size;
		setSize(textWidth * d, textHeight * d);
	}
	
	private function getNewLine(Old:Line, B:Bitmap):Line
	{
		return new Line(this, B, Old.yOffset + Old.getHeight());
	}
}
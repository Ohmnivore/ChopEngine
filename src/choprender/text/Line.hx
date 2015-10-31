package choprender.text;

import choprender.model.data.Bitmap;
import choprender.text.loader.FontBuilderNGL.Font;
import choprender.text.loader.FontBuilderNGL.FontChar;
import chop.math.Vec2;
import chop.math.Vec4;

/**
 * ...
 * @author Ohmnivore
 */
class Line
{
	public var t:Text;
	public var b:Bitmap;
	public var yOffset:Int;
	private var curX:Int;
	
	public function new(T:Text, B:Bitmap, YOffset:Int) 
	{
		t = T;
		b = B;
		yOffset = YOffset;
		curX = 0;
	}
	
	public function hasSpaceForWord(W:String):Bool
	{
		var x:Int = 0;
		var char:FontChar = null;
		for (i in 0...W.length)
		{
			var c:String = W.charAt(i);
			if (TextUtil.isNewline(c))
				continue;
			
			char = t.font.chars.get(c);
			if (char == null)
				char = t.font.chars.get(TextUtil.UNKNOWN_REPLACER);
			x += char.advance;
		}
		if (char != null)
			x += char.rectWidth;
		return curX + x <= t.maxWidthPixel;
	}
	
	public function hasSpaceFor(C:FontChar):Bool
	{
		if (t.mode == Text.AUTO_WIDTH)
			return true;
		return curX + C.rectWidth <= t.maxWidthPixel;
	}
	
	public function addCharacter(C:FontChar):Void
	{
		// Because of inverse y axis
		var cOffsY:Int = t.font.size - C.offsetY;
		
		// Resize the bitmap if needed
		var xDelta:Int = C.rectWidth;
		var yDelta:Int = C.rectHeight + cOffsY;
		if (curX + xDelta >= b.width)
			b.setSize(curX + xDelta, b.height);
		if (yOffset + yDelta >= b.height)
			b.setSize(b.width, yOffset + yDelta);
		
		b.copyPixels(
			t.font.tex,
			b,
			Vec4.fromValues(C.rectX, C.rectY, C.rectWidth, C.rectHeight),
			Vec2.fromValues(curX, yOffset + cOffsY)
		);
		curX += C.advance;
	}
	
	public function getHeight():Int
	{
		return t.font.size;
	}
}
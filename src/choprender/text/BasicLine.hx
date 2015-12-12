package choprender.text;

import glm.Vec2;

/**
 * ...
 * @author Ohmnivore
 */
class BasicLine
{
	public var t:Text;
	public var yOffset:Int;
	private var curX:Int;
	
	public function new(T:Text, YOffset:Int) 
	{
		t = T;
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
		if (curX + xDelta >= getDrawWidth())
			setDrawSize(curX + xDelta, getDrawHeight());
		if (yOffset + yDelta >= getDrawHeight())
			setDrawSize(getDrawWidth(), yOffset + yDelta);
		
		draw(C, cOffsY);
		curX += C.advance;
	}
	
	private function draw(C:FontChar, COffsY:Int):Void
	{
		
	}
	private function getDrawWidth():Int
	{
		return 0;
	}
	private function getDrawHeight():Int
	{
		return 0;
	}
	private function setDrawSize(W:Int, H:Int):Void
	{
		
	}
	
	public function getHeight():Int
	{
		return t.font.size;
	}
}
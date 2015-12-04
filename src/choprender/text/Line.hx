package choprender.text;

import choprender.model.data.Bitmap;
import chop.math.Vec2;
import chop.math.Vec4;
import choprender.text.FontChar;

/**
 * ...
 * @author Ohmnivore
 */
class Line extends BasicLine
{
	public var b:Bitmap;
	public var xOffset:Int;
	
	public function new(T:Text, B:Bitmap, YOffset:Int) 
	{
		super(T, YOffset);
		b = B;
		xOffset = 0;
	}
	
	override function draw(C:FontChar, COffsY:Int):Void 
	{
		b.copyPixels(
			t.font.tex,
			b,
			Vec4.fromValues(C.rectX, C.rectY, C.rectWidth, C.rectHeight),
			Vec2.fromValues(curX + xOffset, yOffset + COffsY)
		);
	}
	override function getDrawWidth():Int 
	{
		return b.width;
	}
	override function getDrawHeight():Int 
	{
		return b.height;
	}
	override private function setDrawSize(W:Int, H:Int):Void 
	{
		b.setSize(W, H);
	}
}
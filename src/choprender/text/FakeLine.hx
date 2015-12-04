package choprender.text;
import choprender.text.FontChar;

/**
 * ...
 * @author Ohmnivore
 */
class FakeLine extends BasicLine
{
	public var width:Int;
	public var height:Int;
	public var realWidth:Int;
	
	public function new(T:Text, W:Int, Y:Int, YOffset:Int) 
	{
		super(T, YOffset);
		width = W;
		height = Y;
		realWidth = 0;
	}
	
	public function getXOffset(MaxDrawWidth:Int):Int
	{
		if (t.alignment == Text.ALIGN_LEFT)
			return 0;
		else if (t.alignment == Text.ALIGN_RIGHT)
			return MaxDrawWidth - realWidth;
		else
			return Math.floor((MaxDrawWidth - realWidth) / 2);
	}
	
	override function draw(C:FontChar, COffsY:Int):Void 
	{
		realWidth = curX + C.rectWidth;
	}
	override function getDrawWidth():Int 
	{
		return width;
	}
	override function getDrawHeight():Int 
	{
		return height;
	}
	override private function setDrawSize(W:Int, H:Int):Void 
	{
		width = W;
		height = H;
	}
}
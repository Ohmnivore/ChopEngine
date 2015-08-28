package chop.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class Animation
{
	public var name:String;
	public var length:Int;
	public var frames:Array<Frame>;
	
	public function new() 
	{
		name = "";
		length = 0;
		frames = [];
	}
}
package choprender.model.data;

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
	
	public function copy(A:Animation):Void
	{
		name = A.name;
		length = A.length;
		frames.splice(0, frames.length);
		
		for (f in A.frames)
		{
			var newf:Frame = new Frame();
			newf.copy(f);
			frames.push(newf);
		}
	}
}
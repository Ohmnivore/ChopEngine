package chop.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class Frame
{
	public var id:Int;
	public var time:Int;
	public var vertices:Array<Vertex>;
	
	public function new() 
	{
		id = 0;
		time = 0;
		vertices = [];
	}
}
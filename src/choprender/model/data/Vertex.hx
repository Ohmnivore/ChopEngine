package choprender.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class Vertex
{
	public var tagID:Int;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var nx:Float;
	public var ny:Float;
	public var nz:Float;
	
	public function new() 
	{
		tagID = 0;
		x = 0;
		y = 0;
		z = 0;
		nx = 0;
		ny = 0;
		nz = 0;
	}
	
	public function copy(V:Vertex):Void
	{
		tagID = V.tagID;
		x = V.x;
		y = V.y;
		z = V.z;
		nx = V.nx;
		ny = V.ny;
		nz = V.nz;
	}
}
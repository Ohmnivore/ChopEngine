package choprender.model.data;

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
	
	public function copy(F:Frame):Void
	{
		id = F.id;
		time = F.time;
		vertices.splice(0, vertices.length);
		
		for (v in F.vertices)
		{
			var newv:Vertex = new Vertex();
			newv.copy(v);
			vertices.push(newv);
		}
	}
}
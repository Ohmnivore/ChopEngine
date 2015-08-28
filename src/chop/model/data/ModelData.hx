package chop.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class ModelData
{
	public var materials:Array<Material>;
	public var faces:Array<Face>;
	public var anims:Map<String, Animation>;
	
	public function new() 
	{
		materials = [];
		faces = [];
		anims = new Map<String, Animation>();
	}
}
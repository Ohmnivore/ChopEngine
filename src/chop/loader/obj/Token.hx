package chop.loader.obj;

/**
 * ...
 * @author Ohmnivore
 */
class Token
{
	public var text:String;
	public var type:Int;
	
	public function new(T:Int, Text:String) 
	{
		type = T;
		text = Text;
	}
}
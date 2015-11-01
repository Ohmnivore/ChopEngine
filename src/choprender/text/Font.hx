package choprender.text;

import choprender.model.data.Bitmap;

/**
 * ...
 * @author Ohmnivore
 */
class Font
{
	public var size:Int;
	public var family:String;
	public var ascender:Int;
	public var height:Int;
	public var descender:Int;
	public var texWidth:Int;
	public var texHeight:Int;
	public var texFile:String;
	public var tex:Bitmap;
	
	public var chars:Map<String, FontChar>;
	
	public function new() 
	{
		chars = new Map<String, FontChar>();
	}
}
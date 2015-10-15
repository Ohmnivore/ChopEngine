package choprender.model.loader;

import choprender.model.data.ModelData;

/**
 * ...
 * @author Ohmnivore
 */
class Loader
{
	public var path:String;
	public var source:String;
	public var data:ModelData;
	
	public function new()
	{
		
	}
	
	public function loadFile(P:String):Void
	{
		path = P;
		var source:String = Main.assets.getText(P);
		loadSource(source);
	}
	
	public function loadSource(Source:String):Void
	{
		source = Source;
		data = new ModelData();
	}
}
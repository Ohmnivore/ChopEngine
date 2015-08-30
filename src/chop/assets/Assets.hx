package chop.assets;

/**
 * ...
 * @author Ohmnivore
 */
class Assets
{
	public static function loadText(ID:String):String
	{
		#if snow
		return sys.io.File.getContent(ID);
		#else
		return lime.Assets.getText(ID);
		#end
	}
	//public static function loadTexts(IDs:Array<String>, OnEnd:Array<String>->Void):Void
	//{
		//SnowApp.
	//}
}
package choprender.text;

/**
 * ...
 * @author Ohmnivore
 */
class TextUtil
{
	static public inline var UNKNOWN_REPLACER:String = " ";
	
	static public function getChar(F:Font, C:String):FontChar
	{
		var char:FontChar = F.chars.get(UNKNOWN_REPLACER);
		if (F.chars.exists(C))
			char = F.chars.get(C);
		return char;
	}
	
	static public function isNewline(C:String):Bool
	{
		return C == "\n" || C == "\r";
	}
}
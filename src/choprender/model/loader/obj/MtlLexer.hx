package choprender.model.loader.obj;

/**
 * ...
 * @author Ohmnivore
 */
class MtlLexer extends Lexer
{
	static public var LNEWLINE:Int = 3;
	static public var LNEWMTL:Int = 4;
	static public var LMTLNAME:Int = 5;
	static public var LAMBIENT:Int = 6;
	static public var LDIFFUSE:Int = 7;
	static public var LSPEC:Int = 8;
	static public var LTRANS:Int = 9;
	
	override private function nextToken():Token
	{
		while (p < source.length)
		{
			if (c == " " || c == "\t")
			{
				WS();
				continue;
			}
			else if (c == "\n" || c == "\r")
			{
				return quickConsume(LNEWLINE);
			}
			else if (isDigit(c))
			{
				return NUM();
			}
			else
			{
				return PARSELONGSTRING();
			}
			consume();
		}
		
		return new Token(Lexer.LEOF, null);
	}
	
	private function PARSELONGSTRING():Token
	{
		var buff:String = getWord();
		
		var ret:Int = LMTLNAME;
		if (buff == "newmtl")
			ret = LNEWMTL;
		if (buff == "Ka")
			ret = LAMBIENT;
		if (buff == "Kd")
			ret = LDIFFUSE;
		if (buff == "Ks")
			ret = LSPEC;
		if (buff == "d" || buff == "Tr")
			ret = LTRANS;
		
		return new Token(ret, buff);
	}
}
package choprender.model.loader.obj;

/**
 * ...
 * @author Ohmnivore
 */
class ObjLexer extends Lexer
{
	static public var LNEWLINE:Int = 3;
	static public var LVAR:Int = 4;
	static public var LFSLASH:Int = 5;
	static public var LPOUND:Int = 6;
	static public var LGEOM:Int = 7;
	static public var LNORM:Int = 8;
	static public var LTEX:Int = 9;
	static public var LPARAM:Int = 10;
	static public var LFACE:Int = 11;
	static public var LUSEMTL:Int = 12;
	
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
			else if (c == "/")
			{
				return quickConsume(LFSLASH);
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
		
		var ret:Int = LVAR;
		if (buff == "v")
			ret = LGEOM;
		if (buff == "vn")
			ret = LNORM;
		if (buff == "vt")
			ret = LTEX;
		if (buff == "vp")
			ret = LPARAM;
		if (buff == "f")
			ret = LFACE;
		if (buff == "#")
			ret = LPOUND;
		if (buff == "usemtl")
			ret = LUSEMTL;
		
		return new Token(ret, buff);
	}
}
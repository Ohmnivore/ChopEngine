package choprender.model.loader.obj;

/**
 * ...
 * @author Ohmnivore
 */
class MtlLexer
{
	static public var LEOF:Int = 0;
	static public var LNEWLINE:Int = 1;
	static public var LNEWMTL:Int = 2;
	static public var LMTLNAME:Int = 3;
	static public var LAMBIENT:Int = 4;
	static public var LDIFFUSE:Int = 5;
	static public var LSPEC:Int = 6;
	static public var LTRANS:Int = 7;
	static public var LFLOAT:Int = 8;
	static public var LINT:Int = 9;
	
	public var source:String;
	public var tokens:Array<Token>;
	
	private var p:Int;
	private var c:String;
	
	public function new() 
	{
		init();
	}
	
	private function init():Void
	{
		source = null;
		tokens = [];
		p = 0;
	}
	
	public function tokenize(Source:String):Void
	{
		init();
		
		source = Source;
		c = source.charAt(0);
		
		var t:Token = nextToken();
		while (t.type != LEOF)
		{
			t = nextToken();
			tokens.push(t);
		}
	}
	
	private function consume():Void
	{
		p++;
		if (p < source.length)
			c = source.charAt(p);
		else
			c = null;
	}
	
	private function quickConsume(T:Int, Text:String = ""):Token
	{
		consume();
		return new Token(T, Text);
	}
	
	private function nextToken():Token
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
		
		return new Token(LEOF, null);
	}
	
	private function WS():Void
	{
		while (c == " " || c == "\t")
			consume();
	}
	
	private function isDigit(Char:String):Bool
	{
		var code:Int = Char.charCodeAt(0);
		return (code >= "0".charCodeAt(0) && code <= "9".charCodeAt(0)) || code == "-".charCodeAt(0);
	}
	
	private function NUM():Token
	{
		var isInt:Bool = true;
		var buff:String = "";
		do
		{
			if (c == ".")
				isInt = false;
			buff += c;
			consume();
		}
		while (c == "." || isDigit(c));
		
		if (isInt)
			return new Token(LINT, buff);
		else
			return new Token(LFLOAT, buff);
	}
	
	private function isLetter(Char:String):Bool
	{
		var code:Int = Char.charCodeAt(0);
		return (code >= "a".charCodeAt(0) && code <= "z".charCodeAt(0)) ||
			(code >= "A".charCodeAt(0) && code <= "Z".charCodeAt(0)) || Char == ".";
	}
	
	private function PARSELONGSTRING():Token
	{
		var buff:String = "";
		do
		{
			buff += c;
			consume();
		}
		while(isLetter(c) || isDigit(c));
		
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
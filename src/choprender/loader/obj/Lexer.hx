package choprender.loader.obj;

/**
 * ...
 * @author Ohmnivore
 */
class Lexer
{
	static public var LEOF:Int = 0;
	static public var LNEWLINE:Int = 1;
	static public var LVAR:Int = 2;
	static public var LINT:Int = 3;
	static public var LFLOAT:Int = 4;
	static public var LFSLASH:Int = 5;
	static public var LPOUND:Int = 6;
	static public var LGEOM:Int = 7;
	static public var LNORM:Int = 8;
	static public var LTEX:Int = 9;
	static public var LPARAM:Int = 10;
	static public var LFACE:Int = 11;
	
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
			(code >= "A".charCodeAt(0) && code <= "Z".charCodeAt(0));
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
		
		return new Token(ret, buff);
	}
}
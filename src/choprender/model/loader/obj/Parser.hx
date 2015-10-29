package choprender.model.loader.obj;

import choprender.model.data.Animation;
import choprender.model.data.Face;
import choprender.model.data.Frame;
import choprender.model.data.Material;
import choprender.model.data.Vertex;
import model.data.*;
import choprender.model.data.ModelData;

/**
 * ...
 * @author Ohmnivore
 */
class Parser
{
	public var tokens:Array<Token>;
	private var p:Int;
	
	public function new()
	{
		init();
	}
	
	public function init():Void
	{
		p = 0;
		tokens = [];
	}
	
	public function parse(Tokens:Array<Token>):Void
	{
		init();
		tokens = Tokens;
	}
	
	public function consume():Void
	{
		p++;
	}
	
	public function LT(I:Int):Token
	{
		return tokens[p + I - 1];
	}
	
	public function LA(I:Int):Int
	{
		return LT(I).type;
	}
	
	public function match(T:Int):Token
	{
		var t:Token = LT(1);
		if (t.type != T)
			throw("Expected token type " + T + " , got type " + t.type);
		return t;
	}
}
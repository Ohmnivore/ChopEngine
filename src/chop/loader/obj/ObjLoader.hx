package chop.loader.obj;

import chop.loader.Loader;

/**
 * ...
 * @author Ohmnivore
 */
class ObjLoader extends Loader
{
	override public function loadSource(Source:String):Void
	{
		super.loadSource(Source);
		
		var lexer:Lexer = new Lexer();
		lexer.tokenize(source);
		var parser:Parser = new Parser();
		parser.parse(lexer.tokens);
		data = parser.data;
	}
}
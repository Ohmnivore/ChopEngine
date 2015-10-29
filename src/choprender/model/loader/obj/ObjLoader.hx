package choprender.model.loader.obj;

import choprender.model.data.ModelData;

/**
 * ...
 * @author Ohmnivore
 */
class ObjLoader
{
	public var path:String;
	public var source:String;
	public var data:ModelData;
	
	public var pathMtl:String;
	public var sourceMtl:String;
	
	public function new()
	{
		
	}
	
	public function loadFile(P:String, PMtl:String):Void 
	{
		path = P;
		var source:String = Main.assets.getText(P);
		pathMtl = PMtl;
		var sourceMtl:String = Main.assets.getText(PMtl);
		loadSource(source, sourceMtl);
	}
	
	public function loadSource(Source:String, SourceMtl:String):Void
	{
		source = Source;
		sourceMtl = SourceMtl;
		
		var lexerMtl:MtlLexer = new MtlLexer();
		lexerMtl.tokenize(sourceMtl);
		var parserMtl:MtlParser = new MtlParser();
		parserMtl.parse(lexerMtl.tokens);
		
		var lexer:ObjLexer = new ObjLexer();
		lexer.tokenize(source);
		var parser:ObjParser = new ObjParser();
		parser.mats = parserMtl.mats;
		parser.parse(lexer.tokens);
		data = parser.data;
	}
}